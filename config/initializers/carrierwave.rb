# encoding : utf-8
require File.join(Rails.root, 'lib/carrierwave/geometry')
require File.join(Rails.root, 'lib/carrierwave/defaults')
require File.join(Rails.root, 'lib/carrierwave/storage/configuration')

CarrierWave.configure do |config|
  config.storage = :file
end

