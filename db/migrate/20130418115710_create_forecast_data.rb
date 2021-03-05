class CreateForecastData < ActiveRecord::Migration
  def change
    create_table :forecast_data do |t|
      t.datetime :timestamp
      t.integer :temperature
      t.string :icon
      t.integer :pressure
      t.float :wind_speen
      t.integer :location_id

      t.timestamps
    end

    add_index :forecast_data, :location_id
  end
end
