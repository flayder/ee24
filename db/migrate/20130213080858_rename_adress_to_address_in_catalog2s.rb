class RenameAdressToAddressInCatalog2s < ActiveRecord::Migration
  def change
    rename_column :catalog2s, :adress, :address
  end
end
