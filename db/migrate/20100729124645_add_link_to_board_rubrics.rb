require 'string'

class AddLinkToBoardRubrics < ActiveRecord::Migration
  def self.up
    add_column :board_rubrics, :link, :string
  end

  def self.down
    remove_column :board_rubrics, :link
  end
end
