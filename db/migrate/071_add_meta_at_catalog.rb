class AddMetaAtCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "meta_title", :string)
    add_column("catalogs", "meta_keywords", :text)
    add_column("catalogs", "meta_description", :text)
    add_column("catalogs", "about", :text)
  end

  def self.down
    remove_column("catalogs", "meta_title")
    remove_column("catalogs", "meta_keywords")
    remove_column("catalogs", "meta_description")
    remove_column("catalogs", "about")
  end
end
