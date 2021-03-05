# encoding : utf-8

class CommunityLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  storage :file
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  version :large do
    process :resize_to_fill => [160, 160]
  end

  version :medium do
    process :resize_to_fill => [90, 90]
  end

  version :mini do
    process :resize_to_fill => [45, 45]
  end

end
