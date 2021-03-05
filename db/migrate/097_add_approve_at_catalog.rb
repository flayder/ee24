class AddApproveAtCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "approved", :boolean, :nil => false, :default => true)
  end

  def self.down
    remove_column("catalogs", "approved")
  end
end
