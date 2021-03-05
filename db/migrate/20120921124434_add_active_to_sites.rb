class AddActiveToSites < ActiveRecord::Migration
  def change
    add_column :sites, :active, :boolean, :default => true
  end
end
