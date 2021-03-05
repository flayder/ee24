# encoding : utf-8

class BankLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  storage :file
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  version :medium do
    process :resize_to_fill => [110, 110]
  end

end
