class AddActiveMainAtPlaceType < ActiveRecord::Migration
  def self.up
    add_column("place_types", "main",  :boolean)
    add_column("place_types", "active",:boolean)
  end

  def self.down
    remove_column("place_types", "main")
    remove_column("place_types", "active")
  end
end
