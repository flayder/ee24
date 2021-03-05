class AddMetaToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :meta_title, :string
    add_column :partners, :meta_keywords, :text
    add_column :partners, :meta_description, :text
  end

  def self.down
    remove_column :partners, :meta_title
    remove_column :partners, :meta_keywords
    remove_column :partners, :meta_description
  end
end