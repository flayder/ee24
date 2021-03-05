class AddCityIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :city_id, :integer, :default => City.voronezh_id
    add_index :events, :city_id
  end

  def self.down
    remove_column :events, :city_id
  end
end