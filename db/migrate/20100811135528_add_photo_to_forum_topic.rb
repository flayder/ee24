class AddPhotoToForumTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :photo, :string
  end

  def self.down
    remove_column :topics, :photo
  end
end
