class CreateSiteAdmins < ActiveRecord::Migration
  def change
    create_table :site_admins do |t|
      t.integer :site_id
      t.integer :user_id

      t.timestamps
    end
    add_index :site_admins, :site_id
    add_index :site_admins, :user_id
  end
end
