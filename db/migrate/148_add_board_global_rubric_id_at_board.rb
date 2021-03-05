class AddBoardGlobalRubricIdAtBoard < ActiveRecord::Migration
  def self.up
    add_column("boards", "board_global_rubric_id", :string)
  end

  def self.down
    remove_column("boards", "board_global_rubric_id")
  end
end
