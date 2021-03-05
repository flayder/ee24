class DeleteNotIndexedFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :not_indexed
  end
end
