class AddIsCommentableToDocsAndCatalogs < ActiveRecord::Migration
  def change
    add_column :docs, :is_commentable, :boolean, default: true
    add_column :catalogs, :is_commentable, :boolean, default: true
  end
end