class AddSeoParamsAtGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "about", :string)
    add_column("galleries", "meta_title", :text)
    add_column("galleries", "meta_keywords", :text)
    add_column("galleries", "meta_description", :text)
  end

  def self.down
    remove_column("galleries", "about")
    remove_column("galleries", "meta_title")
    remove_column("galleries", "meta_keywords")
    remove_column("galleries", "meta_description")
  end
end
