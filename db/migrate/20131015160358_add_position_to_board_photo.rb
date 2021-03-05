class AddPositionToBoardPhoto < ActiveRecord::Migration
  def change
    add_column :board_photos, :position, :integer
    add_index :board_photos, :position
  end
end
