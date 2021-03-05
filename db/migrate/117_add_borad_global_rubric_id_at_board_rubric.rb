class AddBoradGlobalRubricIdAtBoardRubric < ActiveRecord::Migration
  def self.up
    add_column("board_rubrics", "board_global_rubric_id", :integer)
  end

  def self.down
    remove_column("board_rubrics", "board_global_rubric_id", :integer)
  end
end
