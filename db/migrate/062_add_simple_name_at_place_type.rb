class AddSimpleNameAtPlaceType < ActiveRecord::Migration
  def self.up
    add_column("place_types", "simple_title",  :string)
  end

  def self.down
    remove_column("place_types", "simple_title")
  end
end
