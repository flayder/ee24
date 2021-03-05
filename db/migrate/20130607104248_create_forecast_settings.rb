class CreateForecastSettings < ActiveRecord::Migration
  def change
    create_table :forecast_settings do |t|
      t.integer :site_id
      t.string :login
      t.string :password

      t.timestamps
    end

    add_index :forecast_settings, :site_id
  end
end
