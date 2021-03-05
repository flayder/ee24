class AddBackgroundToForecastSettings < ActiveRecord::Migration
  def change
    add_column :forecast_settings, :background, :string
  end
end
