class AddCityAtCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "city_id", :integer, :nil => true)
  end

  def self.down
    remove_column("catalogs", "city_id")
  end
end
