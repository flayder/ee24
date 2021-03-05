# encoding : utf-8
class SharedPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Geometry
  include CarrierWave::Defaults
  include CarrierWave::ImageOptimizer
  include ActionView::Helpers::TextHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  after :remove, :delete_empty_upstream_dirs

  process :resize_to_fill => [470, 246]
  process :add_title
  process :add_logo
  process :optimize

  def add_title
    manipulate! do |image|
      txt = Magick::Draw.new
      txt.font_family = 'helvetica'
      txt.pointsize = 25
      txt.fill = '#ffffff'
      txt.gravity = Magick::NorthWestGravity
      txt.font_weight = Magick::BoldWeight
      image.define('modulate:colorspace', 'HSB')
      image = image.modulate(0.5)
      image = image.blur_image(0, 3)
      image.annotate(txt, 0,0,30,60, word_wrap(model.doc.title, line_width: 30))
      image
    end
  end

  def add_logo
    manipulate! do |img|
      icon = Magick::Image.read(Rails.root.join('public/images/watermark.png')).first
      img.composite!(icon, img.columns - icon.columns - 10, img.rows - icon.rows - 10, Magick::OverCompositeOp)
    end
  end
end
