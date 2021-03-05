class AddIsCommentableToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :is_commentable, :boolean, default: true
  end
end
