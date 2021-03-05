class AddLatAndLng < ActiveRecord::Migration
  def up
    add_column :atms, :lat, :float
    add_column :atms, :lng, :float
    add_column :cities, :lat, :float
    add_column :cities, :lng, :float
    add_column :ad_surfaces, :lat, :float
    add_column :ad_surfaces, :lng, :float
  end

  def down
    remove_column :atms, :lat
    remove_column :atms, :lng

    remove_column :cities, :lat
    remove_column :cities, :lng

    remove_column :ad_surfaces, :lat
    remove_column :ad_surfaces, :lng
  end
end
