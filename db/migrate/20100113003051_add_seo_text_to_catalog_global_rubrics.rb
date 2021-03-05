class AddSeoTextToCatalogGlobalRubrics < ActiveRecord::Migration
  def self.up
    add_column :catalog_global_rubrics, :seo_text, :text
  end

  def self.down
    remove_column :catalog_global_rubrics, :seo_text
  end
end
