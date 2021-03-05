class AddCountAtTopic < ActiveRecord::Migration
  def self.up
    add_column("topics", "replies_count", :integer, :default => 0, :nil => false)
  end
  def self.down
    remove_column("topics", "replies_count")
  end
end
