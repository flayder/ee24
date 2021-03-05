class AddLatAndLongToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalog2s, :lat, :float
    add_column :catalog2s, :lng, :float
    add_column :catalog2s, :gmaps, :boolean
  end
end
