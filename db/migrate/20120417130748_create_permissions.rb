class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :site_admin_id
      t.string  :section

      t.timestamps
    end
    add_index :permissions, :site_admin_id
  end
end
