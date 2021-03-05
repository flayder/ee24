class AddMigratedToAdSurfaces < ActiveRecord::Migration
  def change
    add_column :ad_surfaces, :migrated, :boolean, :default => false
  end
end
