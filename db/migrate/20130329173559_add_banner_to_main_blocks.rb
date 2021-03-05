class AddBannerToMainBlocks < ActiveRecord::Migration
  def change
    add_column :main_blocks, :banner, :text
  end
end
