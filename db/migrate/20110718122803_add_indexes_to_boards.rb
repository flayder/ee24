class AddIndexesToBoards < ActiveRecord::Migration
  def self.up
    add_index :board_rubrics, :board_global_rubric_id
    add_index :boards, :board_global_rubric_id
    add_index :boards, :board_rubric_id
  end

  def self.down
    remove_index :board_rubrics, :board_global_rubric_id
    remove_index :boards, :board_global_rubric_id
    remove_index :boards, :board_rubric_id
  end
end
