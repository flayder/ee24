class AddSeoTextToCatalogs < ActiveRecord::Migration
  def self.up
    add_column :catalogs, :seo_text, :text
  end

  def self.down
    remove_column :catalogs, :seo_text
  end
end
