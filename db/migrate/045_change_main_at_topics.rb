class ChangeMainAtTopics < ActiveRecord::Migration
  def self.up
    remove_column("topics", "main")
    add_column("topics", "main",  :boolean, :default => false)
  end

  def self.down
    remove_column("topics", "main")
    add_column("topics", "main",  :boolean)
  end
end
