class AddSiteIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :site_id, :integer
    add_index :versions, :site_id
  end
end
