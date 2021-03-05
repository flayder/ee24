class AddOldIdToBoardRubricAndBoardGlobalRubric < ActiveRecord::Migration
  def change
    add_column :board_rubrics, :old_id, :integer
    add_column :board_global_rubrics, :old_id, :integer
    add_index :board_rubrics, :old_id
    add_index :board_global_rubrics, :old_id
    add_index :board_rubrics, :site_id
    add_index :board_global_rubrics, :site_id
  end
end
