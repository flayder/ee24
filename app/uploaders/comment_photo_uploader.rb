# encoding : utf-8
class CommentPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Geometry
  include CarrierWave::Defaults
  include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:

  storage :file
  # storage :fog
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  process :optimize

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  version :small do
    process :resize_to_fill => [100, 75]
  end

  version :medium do
    process :change_geometry => '400x>'
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
