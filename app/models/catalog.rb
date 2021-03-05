# encoding : utf-8
class Catalog < ActiveRecord::Base
  include WithSite
  include WithLastUpdatedCache
  include WithModerationNotification
  include WithApproved
  include WithPageViews
  include Tagged
  include WithSimilarDocs

  has_paper_trail

  belongs_to :user

  MAX_RUBRIC_COUNT = 3
  has_many :catalog_join_rubrics
  has_many :rubrics, through: :catalog_join_rubrics, source: :catalog_rubric, after_remove: :update_counts_for_rubric, dependent: :destroy

  has_many :photos, :as => :photo, :order => "main DESC", :dependent => :destroy
  has_many :vacancies
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  has_many :catalog_descriptions, dependent: :destroy

  has_and_belongs_to_many :galleries, :class_name => "Gallery", :join_table => "catalog_galleries", :foreign_key => "catalog_id", :association_foreign_key => "gallery_id"

  attr_accessor :global_rubric_id, :map_label

  scope :with_logo, approved.where("logo IS NOT NULL AND logo != ''").order("title")
  scope :without_logo, approved.where("logo IS NULL OR logo = ''").order("title")
  scope :only_title, select("id, title, counter, all_children_counter, parent_id").order("title")
  scope :with_image, where("logo IS NOT NULL AND logo <> ''")
  scope :without_image, where("logo IS NULL OR logo = ''")
  scope :for_map, where('catalogs.approved = true and lat is not null and lng is not null')
  scope :close_to, lambda { |lat, lng, precision| where('(lat between ? and ?) and (lng between ? and ?)', lat - precision, lat + precision, lng - precision, lng + precision) }

  COMMON_FIELDS = [:catalog_descriptions_attributes, :rubric_ids, :email, :tel, :site_url, :fax, :postal_code, :region_extension, :locality, :street_address, :extended_address, :logo, :logo_cache, :annotation, :remove_logo, :russian_language]
  ADMIN_FIELDS = COMMON_FIELDS | [:position, :site_id, :about, :address, :tag_list, :contact, :meta_title, :meta_keywords, :meta_description, :approved, :gallery_ids, :yandex_geocoded, :hcard_converted, :lat, :lng, :is_commentable, :user_id, :recommend, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS
  accepts_nested_attributes_for :catalog_descriptions

  validates :locality, presence: true
  validates :street_address, presence: true
  validates :tel, presence: true
  validates :site_id, :presence => true
  validate  :rubrics_count_within_bounds

  after_save :update_rubrics_counter

  # TODO
  # set link param before_save

  geocoded_by :street_address, latitude: :lat, longitude: :lng
  before_save :geocode, :set_address # Use Yandex geocoder always

  acts_as_gmappable lat: "lat", lng: "lng", process_geocoding: false

  delegate :city, :to => :site

  mount_uploader :logo, CatalogLogoUploader

  def self.by_language(language = I18n.locale.to_s)
    joins(:catalog_descriptions).where("catalog_descriptions.language = ? AND catalog_descriptions.title <> ''", language).uniq
  end

  def catalog_description
    @catalog_description ||= catalog_descriptions.where(language: I18n.locale.to_s).first
  end

  def title
    catalog_description.try(:title) || ''
  end

  def annotation
    catalog_description.try(:annotation) || ''
  end

  def text
    catalog_description.try(:text) || ''
  end

  def gmaps4rails_infowindow
    "<a href = '#{self.url}'><strong>#{self.title}</strong></a>"
  end

  def locality
    self[:locality] || city.try(:title)
  end

  def map_url
    "/map/company?id=#{id}"
  end

  def url(site = nil, domain = nil)
    if self.rubrics.size > 0
      '/catalog/show/' + self.to_param
    else
      '/catalog/'
    end
  end

  def comments_url(site = nil, domain = nil)
    self.url(site, domain) + '/comments'
  end

  def to_param
    param.present? ? "#{id}-#{param}" : id.to_s
  end

  def logo_alt
    self[:logo_alt].present? ? self[:logo_alt] : self[:title]
  end

  def meta_title(c = nil)
    self[:meta_title].present? ? self[:meta_title] : self[:title]
  end

  def seo_about(c = nil)
    self[:seo_about]
  end

  def meta_description(c = nil)
    self[:meta_description]
  end

  def meta_keywords(c = nil)
    self[:meta_keywords]
  end
=begin
  def similar_places limit = 2
    Catalog.for_rubric(rubric).where('catalogs.id != ?', id).approved.site(site).limit(limit)
  end
=end
  def author_callback(user)
    self.update_attributes(:approved => false) if user.user_type == 'moderator'
  end

  def galleries=(par)
    self.galleries.delete_all

    par.each_pair do |kay, value|
      gallery = Gallery.find(kay.to_i)
      if value == '1'
        self.galleries << gallery
      end
    end
  end

  def set_address(address = self.street_address)
    gaddress = Geocoder.search(address).first
    self.address = gaddress.address if gaddress
  end

  def map_label
    self[:map_label] || 'buildingsIcon'
  end

  private

  def update_rubrics_counter
    if self.approved_changed?
      catalog_join_rubrics.each { |element| element.touch }
    end
  end

  def update_counts_for_rubric(record)
    record.update_counters
  end

  def rubrics_count_within_bounds
    errors.add(:base, :not_selected_rubric_error) if rubrics.blank?
    errors.add(:base, :many_selected_rubric_error) if rubrics.size > MAX_RUBRIC_COUNT
  end
end
