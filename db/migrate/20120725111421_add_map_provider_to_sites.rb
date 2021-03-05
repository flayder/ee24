class AddMapProviderToSites < ActiveRecord::Migration
  def change
    add_column :sites, :map_provider, :string, :default => 'yandex'
  end
end
