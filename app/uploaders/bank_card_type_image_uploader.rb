# encoding : utf-8

class BankCardTypeImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Defaults

  #storage :fog
  storage :file
  #storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

end
