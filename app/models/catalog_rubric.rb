# encoding : utf-8
class CatalogRubric < ActiveRecord::Base
  include SeoValues
  include WithAd
  include WithSite
  include WithLink

  ADMIN_FIELDS = [:title, :english_title, :link, :main, :parent_id, { :as => :admin }]
  attr_accessible *ADMIN_FIELDS

  MAX_DEPTH = 3

  acts_as_nested_set

  has_many :catalog_join_rubrics, dependent: :destroy
  has_many :catalogs, through: :catalog_join_rubrics, dependent: :destroy
  has_many :catalog_rubric_counters, dependent: :destroy

  before_save :set_position, :on => :create

  validates :depth, :inclusion => { :in => 0..MAX_DEPTH }

  scope :only_title, :select => "id, title, counter, all_children_counter, parent_id", :order => "title"

  accepts_nested_attributes_for :seos

  scope :auto_showrooms, where(:id => 17)
  scope :auto_services, where(:id => 1638)
  scope :taxi, where(:id => 7537)
  scope :moto_showrooms, where(:id => 1634)
  scope :carriers, where(:id => 1999)
  scope :railway_stations, where(:id => 1639)

  def counter(language = I18n.locale)
    catalog_rubric_counters.where(language: language.to_s).first.try(:counter) || 0
  end

  def title
    I18n.locale == :ru ? self.read_attribute(:title) : self.english_title
  end

  def skip_before_destroy
    true
  end

  def url
    "/catalog/list/#{self.id}"
  end

  def set_position
    unless self.position?
      cgr = CatalogRubric.select('max(position) as position').first
      self.position = cgr ? cgr.position : 0
    end
  end

  def update_counters
    self.self_and_ancestors.each do |rubric|
      I18n.available_locales.each do |locale|
        catalog_rubric_counter = rubric.catalog_rubric_counters.where(language: locale.to_s).first ||
            rubric.catalog_rubric_counters.create(language: locale.to_s)
        counter = if rubric.catalogs.present?
                    rubric.catalogs.approved.site(rubric.site).by_language(locale).count
                  else
                    rubric.descendants.flat_map{|r| r.catalogs.approved.by_language(locale)}.uniq.count
                  end
        catalog_rubric_counter.update_column(:counter, counter)
      end
    end
  end
end
