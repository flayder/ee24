class AddIsCommentableToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_commentable, :boolean, default: true
  end
end
