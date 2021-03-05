# encoding : utf-8
class CatalogLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  # storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    '/assets/v2/default/photo_medium.png'
  end

  # REHACTOR we need to rename folder in s3 to catalog
  def store_dir
    "system/catalog2/#{mounted_as}/#{get_last_dir_part(model.id)}/#{version_name}"
  end
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

  version :medium do
    process :resize_to_fill => [200, 100]
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #  "something.jpg" if original_filename
  # end

end
