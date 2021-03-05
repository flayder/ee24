class DropTimeZoneInCities < ActiveRecord::Migration
  def change
    remove_column :cities, :time_zone
  end
end
