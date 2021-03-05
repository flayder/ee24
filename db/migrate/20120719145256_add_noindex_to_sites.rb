class AddNoindexToSites < ActiveRecord::Migration
  def change
    add_column :sites, :not_indexed, :boolean, :default => false
  end
end
