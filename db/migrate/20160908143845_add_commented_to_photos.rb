class AddCommentedToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :commented, :boolean, default: false
  end

  def down
    remove_column :photos, :commented
  end
end
