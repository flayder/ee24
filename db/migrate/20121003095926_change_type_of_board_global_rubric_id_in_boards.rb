class ChangeTypeOfBoardGlobalRubricIdInBoards < ActiveRecord::Migration
  def change
    change_column :boards, :board_global_rubric_id, :integer    
  end
end
