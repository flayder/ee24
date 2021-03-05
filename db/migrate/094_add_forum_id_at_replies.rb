class AddForumIdAtReplies < ActiveRecord::Migration
  def self.up
    add_column("replies", "forum_id", :integer, :nil => false)
  end

  def self.down
    remove_column("replies", "forum_id")
  end
end
