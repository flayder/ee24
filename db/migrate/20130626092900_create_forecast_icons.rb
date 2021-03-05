class CreateForecastIcons < ActiveRecord::Migration
  def change
    create_table :forecast_icons do |t|
      t.string :background
      t.integer :site_id
      t.string :name

      t.timestamps
    end

    add_index :forecast_icons, :site_id
  end
end
