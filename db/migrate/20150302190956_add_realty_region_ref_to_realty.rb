class AddRealtyRegionRefToRealty < ActiveRecord::Migration
  def change
    add_column :realties, :realty_region_id, :integer
    add_index :realties, :realty_region_id
  end
end
