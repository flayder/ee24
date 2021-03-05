class AddSiteIdToCatalogGlobalRubrics < ActiveRecord::Migration
  def change
    add_column :catalog_global_rubrics, :site_id, :integer
    add_index :catalog_global_rubrics, :site_id
  end
end
