class DropMetaFieldsFromNewsDocAndDoc < ActiveRecord::Migration
  def change
    remove_column :docs, :meta_title
    remove_column :docs, :meta_keywords
    remove_column :docs, :meta_description
    remove_column :news_docs, :meta_title
    remove_column :news_docs, :meta_keywords
    remove_column :news_docs, :meta_description
    remove_column :news_docs, :about
  end
end
