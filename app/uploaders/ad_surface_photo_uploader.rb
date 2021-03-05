# encoding : utf-8

class AdSurfacePhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :fog
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/assets/ad_surface/" + [version_name, "default_photo.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  version :popup do
    process :resize_to_fill => [300, 225]
  end

  version :small do
    process :resize_to_fill => [120, 90]
  end

end
