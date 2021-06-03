# encoding : utf-8
class AdCode < ActiveRecord::Base
  include WithSite
  belongs_to :ad_section, :polymorphic => true

  AD_SECTION_TYPES = %(Site SiteSection CatalogRubric Dictionary DocGlobalRubric DocRubric RubricDoc EventRubric PhotoRubric DictionaryRubric)
  BANNER_TYPES = [
    :horizontal_top, 
    :horizontal_bottom, 
    :vertical_right, 
    :vertical_right_main, 
    :logo, 
    :vertical_top_right, 
    :doc_text_bottom,
    :mobile_doc_text_bottom,
    :mobile_doc_text_top,
    :mobile_horizontal_top
  ]

  #уникальная валидация по принадлежащей рубрике/секции или по урлу (ну и сайту)
  validates :site_id, :uniqueness => {:scope => [:banner_type, :ad_section_id, :ad_section_type], :message => 'Можно создать только 1 баннер данного типа для раздела/рубрики'}, :if => :section_uniqueness_required?
  validates :site_id, :uniqueness => {:scope => [:banner_type, :url], :message => 'Можно создать только 1 баннер данного типа для страницы'}, :if => :url_uniqueness_required?
  validates :ad_section_type, inclusion: { in: AD_SECTION_TYPES }

  attr_accessible :code, :ad_section_id, :ad_section_type, :url, :banner_type, :title, as: :admin

  def section_uniqueness_required?
    (self.ad_section_id? && self.ad_section_type?)
  end

  def url_uniqueness_required?
    self.url.present?
  end
end
