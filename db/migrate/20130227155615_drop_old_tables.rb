class DropOldTables < ActiveRecord::Migration
  def change
    drop_table :site_rubrics
    remove_column :rubric_twitters, :site_rubric_id
  end
end
