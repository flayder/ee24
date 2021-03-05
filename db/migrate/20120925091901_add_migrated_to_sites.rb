class AddMigratedToSites < ActiveRecord::Migration
  def change
    add_column :sites, :migrated, :boolean, :default => false
  end
end
