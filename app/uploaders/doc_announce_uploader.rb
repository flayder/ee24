class DocAnnounceUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  storage :file
  after :remove, :delete_empty_upstream_dirs

  version :medium do
    process :resize_to_fill => [925, 225]
  end

end
