class RenameCatalog2sTableToCatalogs < ActiveRecord::Migration
  def change
    rename_table :catalog2s, :catalogs
  end
end
