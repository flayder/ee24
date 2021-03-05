class AddUniqueIndexForPermissions < ActiveRecord::Migration
  def change
    add_index :permissions, [:site_admin_id, :section_id], :unique => true
  end
end