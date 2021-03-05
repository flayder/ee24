class RemoveOldBoardGlobalRubricFields < ActiveRecord::Migration
  def up
    remove_column :board_global_rubrics, :count_pokupka
    remove_column :board_global_rubrics, :count_prodasha
  end

  def down
    add_column :board_global_rubrics, :count_pokupka, :integer, :default => 0
    add_column :board_global_rubrics, :count_prodasha, :integer, :default => 0
  end
end
