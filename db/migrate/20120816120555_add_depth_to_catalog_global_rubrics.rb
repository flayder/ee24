class AddDepthToCatalogGlobalRubrics < ActiveRecord::Migration
  def change
    add_column :catalog_global_rubrics, :depth, :integer, :default => 0
  end
end