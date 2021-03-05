class AddCountersAtCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "counter",  :integer, :null => false, :default => 0)
    add_column("catalogs", "all_children_counter",  :integer, :null => false, :default => 0)
  end

  def self.down
    remove_column("catalogs", "counter")
    remove_column("catalogs", "all_children_counter")
  end
end
