class CreateForecastLocations < ActiveRecord::Migration
  def change
    create_table :forecast_locations do |t|
      t.string :name
      t.integer :district_id
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_index :forecast_locations, :district_id
  end
end
