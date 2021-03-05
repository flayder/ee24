class CreateForumResourcePermissions < ActiveRecord::Migration
  def change
    create_table :forum_resource_permissions do |t|
      t.integer :resource_id
      t.string :resource_type
      t.integer :site_admin_id

      t.timestamps
    end

    add_index :forum_resource_permissions, :site_admin_id
    add_index :forum_resource_permissions, [:site_admin_id, :resource_id, :resource_type], :unique => true, :name => 'forum_resource_permissions_uniq_constraint_index'
  end
end
