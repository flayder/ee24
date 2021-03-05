class ChangeForecastDataTimestampToDate < ActiveRecord::Migration
  def change
    add_index :forecast_data, [:location_id, :timestamp], unique: true
  end
end
