class RemoveSeoTextFromCatalogs < ActiveRecord::Migration
  def self.up
    remove_column :catalog2s, :seo_text
    remove_column :catalogs, :seo_text
    remove_column :catalog_global_rubrics, :seo_text
  end

  def self.down
    add_column :catalog2s, :seo_text, :text
    add_column :catalogs, :seo_text, :text
    add_column :catalog_global_rubrics, :seo_text, :text
  end
end
