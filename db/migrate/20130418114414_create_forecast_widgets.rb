class CreateForecastWidgets < ActiveRecord::Migration
  def change
    create_table :forecast_widgets do |t|
      t.string :url
      t.integer :location_id

      t.timestamps
    end

    add_index :forecast_widgets, :location_id
  end
end
