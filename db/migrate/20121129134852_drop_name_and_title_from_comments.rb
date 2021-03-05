class DropNameAndTitleFromComments < ActiveRecord::Migration
  def change
  	remove_column :comments, :name
  	remove_column :comments, :title
  end
end
