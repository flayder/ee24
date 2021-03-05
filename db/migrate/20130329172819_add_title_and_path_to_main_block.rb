class AddTitleAndPathToMainBlock < ActiveRecord::Migration
  def change
    add_column :main_blocks, :title, :string
    add_column :main_blocks, :path, :string
  end
end
