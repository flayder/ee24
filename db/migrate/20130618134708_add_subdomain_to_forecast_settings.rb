class AddSubdomainToForecastSettings < ActiveRecord::Migration
  def change
    add_column :forecast_settings, :subdomain, :string
  end
end
