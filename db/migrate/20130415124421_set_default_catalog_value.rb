class SetDefaultCatalogValue < ActiveRecord::Migration
  def change
    change_column_default :catalogs, :approved, false
  end
end
