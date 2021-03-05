# encoding : utf-8
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Geometry
  include CarrierWave::Defaults
  include CarrierWave::ImageOptimizer
  include ActionView::Helpers::TextHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  after :remove, :delete_empty_upstream_dirs

  process :optimize

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/assets/v2/default/" + ['photo_', version_name, ".png"].compact.join
  end

  def watermark
    if icon_path = Settings.watermark.try(:file).try(:file)

      Rails.logger.info icon_path
      Rails.logger.info '--- manipulate ---'

      manipulate! do |img|
        icon = Magick::Image.read(icon_path).first
        img.composite!(icon, img.columns - icon.columns - 10, img.rows - icon.rows - 10, Magick::OverCompositeOp)
      end
    end
  end

  #TODO need refactoring!

  version :xxxlarge do
    process :resize_to_fit => [925, 620]
  end

  version :xxlarge do
    process :resize_to_fill => [610, 415]
  end

  version :xlarge do
    process :resize_to_fill => [480, 370]
  end

  version :large do
    process :resize_to_fill => [295, 200]
  end

  version :long do
    process :resize_to_fill => [295, 415]
  end

  version :medium do
    process :resize_to_fill => [190, 130]
  end

  version :small do
    process :resize_to_fill => [190, 130]
  end

  version :xsmall do
    process :resize_to_fill => [85, 70]
  end

  version :xxsmall do
    process :resize_to_fill => [75, 75]
  end

  protected

  def need_watermark?(new_file)
    model.need_watermark?
  end

  def doc?(new_file)
    model.photo_type == 'Doc'
  end
end
