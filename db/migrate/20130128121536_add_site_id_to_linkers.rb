class AddSiteIdToLinkers < ActiveRecord::Migration
  def change
    add_column :linkers, :site_id, :integer
    add_index :linkers, :site_id
  end
end
