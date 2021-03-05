class AddCommentToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :comment, :string, :default => ''
  end

  def self.down
    remove_column :photos, :comment
  end
end
