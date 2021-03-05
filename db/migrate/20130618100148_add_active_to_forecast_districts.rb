class AddActiveToForecastDistricts < ActiveRecord::Migration
  def change
    add_column :forecast_districts, :active, :boolean, default: true
  end
end
