# encoding : utf-8
module CarrierWave
  module Defaults

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      #if model.respond_to?(:migrated?) && model.migrated?
      "system/#{model.class.to_s.underscore}/#{mounted_as}/#{get_last_dir_part(model.id)}/#{version_name}"
      #else
      #  "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/#{version_name}"
      #end
    end

    ## define how to partition directory
    def get_last_dir_part(model_id)
      p = model_id.to_s.rjust(9, '0')
      "#{p[0,3]}/#{p[3,3]}/#{p[6,3]}"
    end

    ## TAKEN FROM GITHUB
    ## https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Make-a-fast-lookup-able-storage-directory-structure
    def delete_empty_upstream_dirs
      path = ::File.expand_path(store_dir, root)
      Dir.delete(path) # fails if path not empty dir
    rescue SystemCallError
      true # nothing, the dir is not empty
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    # TODO temporary comment for seeds
    # def extension_white_list
    #   %w(jpg jpeg gif png bmp ico)
    # end

    #чтобы не перегенеривать картинки, созданные file_column
    def full_filename(for_file)
      for_file
    end
  end
end
