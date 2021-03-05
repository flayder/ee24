class AddRealtyCityRefToRealtyLocality < ActiveRecord::Migration
  def change
    add_column :realty_localities, :realty_city_id, :integer
    add_index :realty_localities, :realty_city_id
  end
end
