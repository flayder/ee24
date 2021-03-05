class DropMetaFieldsFromEvents < ActiveRecord::Migration
  def change
    remove_column :docs, :about
    remove_column :events, :meta_title
    remove_column :events, :meta_keywords
    remove_column :events, :meta_description
    remove_column :events, :about
  end
end
