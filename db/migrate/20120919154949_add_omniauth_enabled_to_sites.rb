class AddOmniauthEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :omniauth_enabled, :boolean, :default => false
  end
end