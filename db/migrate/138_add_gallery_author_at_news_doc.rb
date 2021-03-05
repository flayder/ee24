class AddGalleryAuthorAtNewsDoc < ActiveRecord::Migration
  def self.up
    add_column("news_docs", "gallery_author", :string)
  end

  def self.down
    remove_column("news_docs", "gallery_author")
  end
end
