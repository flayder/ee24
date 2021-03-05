class FixNameTypeInLocationWindSpeed < ActiveRecord::Migration
  def change
    rename_column :forecast_data, :wind_speen, :wind_speed
  end
end
