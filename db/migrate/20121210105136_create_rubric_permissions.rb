class CreateRubricPermissions < ActiveRecord::Migration
  def change
    create_table :rubric_permissions do |t|
      t.integer :rubric_id
      t.string :rubric_type
      t.integer :site_admin_id

      t.timestamps
    end

    add_index :rubric_permissions, :site_admin_id
    add_index :rubric_permissions, 
      [:site_admin_id, :rubric_id, :rubric_type], 
      :unique => true,
      :name => 'rubric_permissions_site_admin_rubric_constraint'
  end
end