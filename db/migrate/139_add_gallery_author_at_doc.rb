class AddGalleryAuthorAtDoc < ActiveRecord::Migration
  def self.up
    add_column("docs", "gallery_author", :string)
  end

  def self.down
    remove_column("docs", "gallery_author")
  end
end
