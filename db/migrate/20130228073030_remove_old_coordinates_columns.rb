class RemoveOldCoordinatesColumns < ActiveRecord::Migration
  def up
    %w(atms catalogs cities ad_surfaces).each do |table|
      remove_column table, :latitude
      remove_column table, :longitude
    end
  end

  def down
    %w(atms cities ad_surfaces).each do |table|
      add_column table, :latitude, :string
      add_column table, :longitude, :string
    end    
    add_column :catalogs, :latitude, :float
    add_column :catalogs, :longitude, :float
  end
end
