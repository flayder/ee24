class AddCounterToBoardRubrics < ActiveRecord::Migration
  def change
    add_column :board_rubrics, :counter, :integer, :default => 0
  end
end
