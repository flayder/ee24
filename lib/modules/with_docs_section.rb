# encoding : utf-8
module Modules
  module WithDocsSection
    extend ActiveSupport::Concern

    included do
      before_filter :get_rubric, :get_rubric_ads, :only => [:rubric, :show, :show_doc, :comments]
      before_filter :get_global_rubric_ads, :get_ads
    end

    private
    def get_rubric_ads
      unless @layout_params[:no_banners]
        set_rubric_ads(@rubric) if @rubric
      end
    end

    def get_global_rubric_ads
      unless @layout_params[:no_banners]
        set_rubric_ads(@global_rubric) if @global_rubric
      end
    end

    def get_rubric
      @rubric = @global_rubric.doc_rubrics.link(params[:rubric]).first!
    rescue ActiveRecord::RecordNotFound
      render_404
    end

    def set_section
      @section = @site.site_sections.joins(:section).where(sections: { controller: :docs }).first
      @global_rubric = @section.rubrics(params[:controller]).first
    end

    def set_no_banners
      @layout_params[:no_banners] = true if @site.voronezh?
    end
  end
end
