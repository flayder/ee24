# encoding : utf-8
module Modules
  module WithCommonLayout
    def self.included(base)
      base.class_eval {
        before_filter :set_layout_params
        before_filter :find_social_codes
      }
    end

    protected
    def need_more_ads?
      @ad_codes.count < AdCode::BANNER_TYPES.count
    end

    def set_layout_params
      @layout_params = layout_params
    end

    def layout_params
      {}
    end

    def set_section
      controller = self.private_methods.include?(:section_controller) ? self.send(:section_controller) : params[:controller]
      # TODO
      # rename to site_section, because it is SiteSection
      @section = @site.site_sections.joins(:section).where(sections: { controller: controller }).first!
    end

    def set_rubric_ads(rubric)
      banners = rubric.ad_codes.site(@site)
      banners.each do |banner|
        @ad_codes[banner.banner_type] ||= banner.code
      end
    end

    def get_ads
      #рекламные коды для раздела
      @ad_codes ||= {}

      if need_more_ads? && @section
        @section.ad_codes.each do |banner|
          @ad_codes[banner.banner_type] ||= banner.code
        end
      end
    end

    def find_social_codes
      if @site.voronezh? && request.path =~ /\A\/news\/vktv/
        @social_codes = @site.social_widget_codes.where(:widget_type => ['vktv', 'fb_vktv'])
      else
        @social_codes = @site.social_widget_codes.where(:widget_type => ['vk', 'fb'])
      end
    end
  end
end
