class AddLinkToCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "link",  :string)
  end

  def self.down
    remove_column("catalogs", "link")
  end
end
