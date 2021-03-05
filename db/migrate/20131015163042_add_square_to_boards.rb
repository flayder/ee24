class AddSquareToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :square, :float
  end
end
