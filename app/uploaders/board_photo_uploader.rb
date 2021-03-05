# encoding : utf-8
class BoardPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Geometry
  include CarrierWave::Defaults
  include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:
  storage :file
  after :remove, :delete_empty_upstream_dirs

  process :optimize

  version :small do
    process :resize_to_fill => [100, 75]
  end

  version :medium do
    process :change_geometry => '450x>'
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  #чтобы не перегенеривать картинки, созданные file_column
  def full_filename(for_file)
    for_file
  end
end
