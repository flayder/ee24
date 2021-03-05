class AddWindDirectionToForecastData < ActiveRecord::Migration
  def change
    add_column :forecast_data, :wind_direction, :string
  end
end
