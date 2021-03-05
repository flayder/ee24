class AddParamToForecastLocations < ActiveRecord::Migration
  def change
    add_column :forecast_locations, :param, :string
  end
end
