class AddArchivedFlagToBoardRubrics < ActiveRecord::Migration
  def self.up
    add_column :board_rubrics, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :board_rubrics, :archived
  end
end