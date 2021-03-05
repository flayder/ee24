class RemoveAdriverFieldsFromCatalogGlobalRubrics < ActiveRecord::Migration
  def up
    remove_column :catalog_global_rubrics, :adriver_970x90_code
    remove_column :catalog_global_rubrics, :adriver_240x400_code
  end

  def down
    add_column :catalog_global_rubrics, :adriver_970x90_code, :text, :default => ''
    add_column :catalog_global_rubrics, :adriver_240x400_code, :text, :default => ''
  end
end
