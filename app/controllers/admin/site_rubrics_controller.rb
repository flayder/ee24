# encoding : utf-8
class Admin::SiteRubricsController < Admin::BaseController
  authorize_resource :site_rubric

  def index
    @sections = @site.site_sections.order('sections.with_rubrics desc').includes(:section)
  end
end
