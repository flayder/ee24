class RemoveDefaultFromCatalog2sAndDropOldCatalogs < ActiveRecord::Migration
  def change
    drop_table :catalogs
    change_column_default :catalog2s, :approved, nil
  end
end
