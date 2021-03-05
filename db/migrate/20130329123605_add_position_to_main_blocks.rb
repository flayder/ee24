class AddPositionToMainBlocks < ActiveRecord::Migration
  def change
    add_column :main_blocks, :position, :integer
  end
end
