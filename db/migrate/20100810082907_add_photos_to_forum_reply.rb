class AddPhotosToForumReply < ActiveRecord::Migration
  def self.up
    add_column :replies, :photo, :string
  end

  def self.down
    remove_column :replies, :photo
  end
end
