class AddCounterToBoardGlobalRubrics < ActiveRecord::Migration
  def change
    add_column :board_global_rubrics, :counter, :integer, :default => 0
  end
end
