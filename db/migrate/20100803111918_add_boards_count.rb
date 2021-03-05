class AddBoardsCount < ActiveRecord::Migration
  def self.up
    add_column :board_rubrics, :boards_count, :integer, :default => 0
  end

  def self.down
    remove_column :board_rubrics, :boards_count
  end
end
