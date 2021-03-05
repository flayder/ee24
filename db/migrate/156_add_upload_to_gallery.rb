class AddUploadToGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "upload", :string)
    add_column("galleries", "run_upload", :boolean, :nil => false, :default => false)
  end

  def self.down
    remove_column("galleries", "upload")
    remove_column("galleries", "run_upload")
  end
end