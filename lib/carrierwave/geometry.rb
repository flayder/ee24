# encoding : utf-8
module CarrierWave
  module Geometry
    module ClassMethods

      def change_geometry(format)
        process :change_geometry => format
      end

    end

    def change_geometry(format)
      manipulate! do |img|
        img.change_geometry(format) do |new_width, new_height|
          img.resize(new_width, new_height)
        end
      end
    end

  end
end
