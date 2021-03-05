class AddCommentCounterAtGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "comment_counter", :integer, :nil => false, :default => 0)
  end

  def self.down
    remove_column("galleries", "comment_counter")
  end
end
