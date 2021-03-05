class AddCoordinateAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "latitude",  :double)
    add_column("places", "longitude",  :double)
  end

  def self.down
    remove_column("places", "latitude")
    remove_column("places", "longitude")
  end
end
