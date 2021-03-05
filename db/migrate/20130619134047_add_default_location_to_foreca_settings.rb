class AddDefaultLocationToForecaSettings < ActiveRecord::Migration
  def change
    add_column :forecast_settings, :default_location_id, :integer
  end
end
