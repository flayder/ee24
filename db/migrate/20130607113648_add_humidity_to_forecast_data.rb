class AddHumidityToForecastData < ActiveRecord::Migration
  def change
    add_column :forecast_data, :humidity, :integer
  end
end
