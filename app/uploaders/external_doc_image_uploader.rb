class ExternalDocImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  storage :file
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  version :medium do
    process :resize_to_fill => [295, 250]
  end

  version :large do
    process :resize_to_fill => [295, 200]
  end
end
