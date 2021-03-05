# encoding : utf-8

class FaviconUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Defaults

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  # storage CarrierWave::Storage::FileAndFog
  after :remove, :delete_empty_upstream_dirs

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_fill => [16, 16]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(gif)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
