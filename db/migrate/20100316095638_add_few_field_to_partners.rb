class AddFewFieldToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :seo_link_title, :string
    add_column :partners, :seo_link, :string
  end

  def self.down
    remove_column :partners, :seo_link_title
    remove_column :partners, :seo_link
  end
end
