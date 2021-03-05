class AddNightIconToWeather < ActiveRecord::Migration
  def change
    rename_column :weathers, :icon, :day_icon
    add_column :weathers, :night_icon, :string
    remove_column :cities, :meteoinfo_id
  end
end
