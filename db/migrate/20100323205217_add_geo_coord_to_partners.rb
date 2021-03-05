class AddGeoCoordToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :latitude, :float
    add_column :partners, :longitude, :float
  end

  def self.down
    remove_column :partners, :latitude
    remove_column :partners, :longitude
  end
end
