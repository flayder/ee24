class AddMetaInfoForStaticPages < ActiveRecord::Migration
  def self.up
    add_column :static_docs, :meta_title, :string
    add_column :static_docs, :meta_keywords, :text
    add_column :static_docs, :meta_description, :text
  end

  def self.down                               
    remove_column :static_docs, :meta_title
    remove_column :static_docs, :meta_keywords
    remove_column :static_docs, :meta_description
  end
end
