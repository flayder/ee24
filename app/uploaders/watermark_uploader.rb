class WatermarkUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults
  
  #storage CarrierWave::Storage::FileAndFog
  storage :file

  def extension_white_list
    %w(gif png jpg)
  end
end