class RenameCatalogGlobalRubrics < ActiveRecord::Migration
  def up
    rename_table :catalog_global_rubrics, :catalog_rubrics
    rename_column :catalogs, :catalog_global_rubric_id, :catalog_rubric_id
  end

  def down
    rename_table :catalog_rubrics, :catalog_global_rubrics
    rename_column :catalogs, :catalog_rubric_id, :catalog_global_rubric_id    
  end
end
