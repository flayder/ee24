# encoding : utf-8
class Gallery < ActiveRecord::Base
  include WithLastUpdatedCache
  include WithSite
  include WithMainPhoto
  include WithApproved
  include WithModerationNotification
  include WithPageViews
  include Tagged
  include WithSimilarDocs
  include WithPreviewSecret

  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ApplicationHelper
  end

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  belongs_to :photo_rubric
  belongs_to :rubric, :class_name => :PhotoRubric, :foreign_key => :photo_rubric_id
  belongs_to :site
  belongs_to :user

  before_save :post_lj

  scope :without_my_voronezh, :conditions => "photo_rubric_id != 18" # Без галерей из раздела Мой Воронеж
  scope :last_week, lambda { where(galleries: { created_at: (Time.now - 1.week)..(Time.now) }) }

  validates_presence_of :title, :annotation, :photo_rubric_id

  validate :photos_presence, :if => :from_user

  attr_accessor :from_user

  COMMON_FIELDS = [:title, :photo_rubric_id, :annotation, :photos_attributes]
  ADMIN_FIELDS = COMMON_FIELDS | [:not_on_main, :no_watermark, :site_id, :approved, :tag_list, :meta_title, :meta_keywords, :meta_description, :about, :annotation_card, :post_lj, :created_at, :is_commentable, :user_id, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  def self.last_updated
    order('updated_at').last
  end

  def self.cache_keys
    [/block_photo_sliders_/, /photo_/]
  end

  def random_photo
    self.photos.order('rand()').first
  end

  def url(site = nil)
    host = Rails.env == 'production' ? "#{Settings['default_protocol']}://#{Settings['default_host_name']}" : ''
    host + list_url
  end

  def comments_url(site = nil, domain = nil)
    url(site)
  end

  def post_lj
    if self.post_lj?
      self.post_lj = false
      post_to_lj!
    end
    return true
  end

  def main_photo
    photos.main.first || photos.first
  end

  # RENAME this method, it is not ancestors at all
  def ancestors
    photo_rubric.self_and_ancestors
  end

  def list_url
    url = '/photo'
    url +=  "/#{self.rubric.link}" if self.rubric.present?
    url +=  "/list/#{self.id}"
    return url
  end

  def link
    url = ''
    url << 'https://'+self.site.domain unless self.site.nil?
    url << "/photo/list/#{self.id}"
  end

  def post_to_lj!
    Resque.enqueue LjJob, title, lj_body, 'gallery'
  end

  def lj_body
    body = ""
    body << self.annotation
    body << "<br /><br />"

    if self.photos.any?
      self.photos.each_with_index do |photo, i|
        break if i > 9
        body << "<img src=\"#{help.url_for_file_column(photo, 'image', 'small')}\" style=\"margin: 0 10px 10px 0;\">"
      end
      body << "<a href=\"#{link}\"><p style=\"font-size: 14px;\">остальные фото</p></a>"
    end

    body
  end

  private

  def photos_presence
    if self.photos.empty?
      self.errors.add(:photos, 'необходимо загрузить')
    end
  end
end
