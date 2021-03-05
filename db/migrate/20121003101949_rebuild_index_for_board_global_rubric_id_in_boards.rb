class RebuildIndexForBoardGlobalRubricIdInBoards < ActiveRecord::Migration
  def change
    remove_index :boards, :name => :index_boards_on_board_global_rubric_id
    add_index :boards, :board_global_rubric_id
  end
end
