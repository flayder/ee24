class FixUrbanFlagForBoards < ActiveRecord::Migration
  def self.up
    change_column :boards, :is_urban, :boolean, :default => false
  end

  def self.down
    change_column :boards, :is_urban, :boolean, :default => true
  end
end
