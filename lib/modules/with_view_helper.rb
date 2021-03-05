# encoding : utf-8
module Modules
  module WithViewHelper
    def help
      Helper.instance
    end

    class Helper
      include Singleton
      include ActionView::Helpers::TextHelper
    end
  end
end
