class AddSiteIdToForumGroup < ActiveRecord::Migration
  def change
    add_column :forums_groups, :site_id, :integer
    add_index  :forums_groups, :site_id
  end
end
