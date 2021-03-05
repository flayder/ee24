class RemoveOldColumnsFromPartners < ActiveRecord::Migration
  def self.up
    remove_column :partners, :description
    remove_column :partners, :contacts
    remove_column :partners, :contacts_map
    remove_column :partners, :seo_link
    remove_column :partners, :seo_link_title
    remove_column :partners, :latitude
    remove_column :partners, :longitude
    remove_column :partners, :address
    remove_column :partners, :meta_title
    remove_column :partners, :meta_description
    remove_column :partners, :meta_keywords
  end

  def self.down
    add_column :partners, :description, :text
    add_column :partners, :contacts, :text
    add_column :partners, :contacts_map, :string
    add_column :partners, :seo_link, :string
    add_column :partners, :seo_link_title, :string
    add_column :partners, :latitude, :string
    add_column :partners, :longitude, :string
    add_column :partners, :address, :string
    add_column :partners, :meta_title, :string
    add_column :partners, :meta_description, :text
    add_column :partners, :meta_keywords, :text
  end
end
