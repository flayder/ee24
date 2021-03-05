require 'string'

class AddLinkToBoardTypes < ActiveRecord::Migration
  def self.up
    add_column :board_types, :link, :string
  end

  def self.down
    remove_column :board_types, :link
  end
end
