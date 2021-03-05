class SitemapController < ApplicationController
  def index
    @news_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'news').first!
    @afisha_rubrics = @site.event_rubrics
    @catalog_rubrics = @site.catalog_rubrics.roots.order('position, title')
    @job_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'job').first!
    @immigration_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'immigration').first!
    @travel_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'travel').first!
    @magazine_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'magazine').first!
    @photos_rubrics = @site.photo_rubrics
    @realty_rubric = DocGlobalRubric.where(site_id: @site.id, link: 'realty').first!
    @tags = ActsAsTaggableOn::Tag.site(@site)
  end
end
