# encoding : utf-8
class SiteSection < ActiveRecord::Base
  include WithAd
  include WithSite

  belongs_to :section

  validates :section_id, :presence => true
  validates_uniqueness_of :site_id, :scope => :section_id

  delegate :title, :to => :section

  attr_accessible :site_id, :section_id

  def rubric_klass
    case section.controller.to_s
      when 'docs'
        DocGlobalRubric
      when 'afisha'
        EventRubric
      when 'catalog'
        CatalogRubric
      when 'photo'
        PhotoRubric
      else
        DocGlobalRubric
    end
  end

  def rubrics link = nil
    rubrics = rubric_klass.site(site)
    rubrics = rubrics.link(link) if link
    rubrics
  end

  def root_site_rubrics
    case section.controller
      when 'catalog'
        site.catalog_rubrics.roots
      when 'photo'
        site.photo_rubrics
      when 'docs'
        site.doc_global_rubrics
      when 'afisha'
        site.event_rubrics
    end
  end
end
