class AddSiteIdToBoardRubricAndBoardGlobalRubric < ActiveRecord::Migration
  def change
    add_column :board_rubrics, :site_id, :integer
    add_column :board_global_rubrics, :site_id, :integer
  end
end
