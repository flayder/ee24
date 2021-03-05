class AddPhotoToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :photo, :string
  end

  def self.down
    remove_column :comments, :photo
  end
end
