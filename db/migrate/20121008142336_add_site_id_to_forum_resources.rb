class AddSiteIdToForumResources < ActiveRecord::Migration
  def change
    add_column :forums, :site_id, :integer, :null => false
    add_column :topics, :site_id, :integer, :null => false
    add_column :replies, :site_id, :integer, :null => false
    add_index :forums, :site_id
    add_index :topics, :site_id
    add_index :replies, :site_id
  end
end
