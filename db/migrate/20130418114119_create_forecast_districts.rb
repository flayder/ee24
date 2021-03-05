class CreateForecastDistricts < ActiveRecord::Migration
  def change
    create_table :forecast_districts do |t|
      t.string :name
      t.integer :site_id

      t.timestamps
    end

    add_index :forecast_districts, :site_id
  end
end
