class AddOldIdToCatalogGlobalRubric < ActiveRecord::Migration
  def change
    add_column :catalog_global_rubrics, :old_id, :integer
    add_index :catalog_global_rubrics, :old_id
  end
end
