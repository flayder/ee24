class AddCatalogIdToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :catalog_id, :integer
    add_index :boards, :catalog_id
  end
end
