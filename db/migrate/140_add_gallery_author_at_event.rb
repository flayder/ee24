class AddGalleryAuthorAtEvent < ActiveRecord::Migration
  def self.up
    add_column("events", "gallery_author", :string)
  end

  def self.down
    remove_column("events", "gallery_author")
  end
end
