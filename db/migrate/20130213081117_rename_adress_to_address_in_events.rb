class RenameAdressToAddressInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :adress, :address
  end
end
