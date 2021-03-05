class AddActiveAndRegionAtCity < ActiveRecord::Migration
  def self.up
    add_column("cities", "region", :string)
    add_column("cities", "active", :boolean, :default => false, :nil => false)
    add_column("cities", "created_at", :datetime)
    add_column("cities", "number", :string)
  end

  def self.down
    remove_column("cities", "region")
    remove_column("cities", "active")
    remove_column("cities", "created_at")
    remove_column("cities", "number")
  end
end
