# encoding : utf-8
module Modules
  module WithSidebarPhotoSlider
    def self.included(base)
      base.class_eval {
        before_filter :get_photo_sliders
      }
    end

    private
    def get_photo_sliders
      if @site.has_section? :photo
        @photo_sliders = Gallery.site(@site).approved.where(not_on_main: false).order('created_at DESC').limit(3)
      end
    end
  end
end
