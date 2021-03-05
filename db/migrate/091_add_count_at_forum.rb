class AddCountAtForum < ActiveRecord::Migration
  def self.up
    add_column("forums", "replies_count", :integer, :default => 0, :nil => false)
    add_column("forums", "topics_count", :integer, :default => 0, :nil => false)
  end

  def self.down
    remove_column("forums", "replies_count")
    remove_column("forums", "topics_count")
  end
end
