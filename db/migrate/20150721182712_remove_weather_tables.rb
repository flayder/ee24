class RemoveWeatherTables < ActiveRecord::Migration
  def up
    drop_table :weathers
    remove_column :cities, :google_weather_id
  end

  def down
    create_table :weathers do |t|
      t.integer :city_id
      t.date :date
      t.integer :temp_low
      t.integer :temp_high
      t.string :icon
      t.string :comment, :default => ''

      t.timestamps
    end
    add_index :weathers, :city_id

    add_column :cities, :google_weather_id, :string, :default => ''
  end
end
