class AddMaxTemperatureAndMinTemperatureToForecastData < ActiveRecord::Migration
  def change
    add_column :forecast_data, :max_temperature, :integer
    add_column :forecast_data, :min_temperature, :integer
  end
end
