class AddMigratedToCatalog2s < ActiveRecord::Migration
  def change
  	add_column :catalog2s, :migrated, :boolean, :default => false
  end
end
