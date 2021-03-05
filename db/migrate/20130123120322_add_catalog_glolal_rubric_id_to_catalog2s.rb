class AddCatalogGlolalRubricIdToCatalog2s < ActiveRecord::Migration
  def change
    add_column :catalog2s, :catalog_global_rubric_id, :integer
    add_index :catalog2s, :catalog_global_rubric_id
  end
end
