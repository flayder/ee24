class AddMapZoomToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :map_zoom, :string
  end

  def self.down
    remove_column :cities, :map_zoom
  end
end
