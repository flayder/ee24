class AddMetaTagsAtPartnerStaticDocs < ActiveRecord::Migration
  def self.up
    add_column :partner_static_docs, :meta_title, :string
    add_column :partner_static_docs, :meta_keywords, :text
    add_column :partner_static_docs, :meta_description, :text
  end

  def self.down
    remove_column :partner_static_docs, :meta_title
    remove_column :partner_static_docs, :meta_keywords
    remove_column :partner_static_docs, :meta_description
  end
end
