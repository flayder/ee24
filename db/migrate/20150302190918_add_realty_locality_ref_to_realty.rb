class AddRealtyLocalityRefToRealty < ActiveRecord::Migration
  def change
    add_column :realties, :realty_locality_id, :integer
    add_index :realties, :realty_locality_id
  end
end
