class AddLinkToBoardGlobalRubric < ActiveRecord::Migration
  def self.up
    add_column("board_global_rubrics", "link", :string)
  end

  def self.down
    remove_column("board_global_rubrics", "link")
  end
end
