class RemoveOldIdFromJobTables < ActiveRecord::Migration
  def up
    remove_column :professions, :old_id
    remove_column :industries, :old_id
  end

  def down
    add_column :professions, :old_id, :integer
    add_column :industries, :old_id, :integer
  end
end
