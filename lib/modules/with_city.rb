# encoding : utf-8
module Modules
  module WithCity
    def self.included(base)
      base.class_eval do
        before_filter :redirect_unless_city
      end
    
      private
      def redirect_unless_city
        redirect_to root_path unless @site.city
      end
    end
  end
end
