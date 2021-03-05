class ChangeCitiesData < ActiveRecord::Migration
  def self.up
    change_column :cities, :latitude, :string
    change_column :cities, :longitude, :string
    change_column :partners, :latitude, :string
    change_column :partners, :longitude, :string
  end

  def self.down
    change_column :cities, :latitude, :float
    change_column :cities, :longitude, :float
    change_column :partners, :latitude, :float
    change_column :partners, :longitude, :float
  end
end
