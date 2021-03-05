class ChangePermissionFields < ActiveRecord::Migration
  def up
    change_table :permissions do |t|
      t.remove :section
      t.integer :section_id
    end
    add_index :permissions, :section_id
  end

  def down
    change_table :permissions do |t|
      t.string :section, :default => ''
      t.remove :section_id
    end
  end
end
