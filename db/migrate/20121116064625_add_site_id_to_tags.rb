class AddSiteIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :site_id, :integer
    add_index :tags, :site_id
  end
end
