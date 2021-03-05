class DropArchivedAndCountFieldsInBoardRubric < ActiveRecord::Migration
  def change
    remove_column :board_rubrics, :count_pokupka
    remove_column :board_rubrics, :count_prodasha
    remove_column :board_rubrics, :archived
  end
end
