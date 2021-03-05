class AddGoogleWeatherIdToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :google_weather_id, :string, :default => ''
  end

  def self.down
    remove_column :cities, :google_weather_id
  end
end
