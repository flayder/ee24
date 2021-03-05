class DeleteBoardsCounterCache < ActiveRecord::Migration
  def self.up
    remove_column :board_rubrics, :boards_count
  end

  def self.down
    add_column :board_rubrics, :boards_count, :integer
  end
end