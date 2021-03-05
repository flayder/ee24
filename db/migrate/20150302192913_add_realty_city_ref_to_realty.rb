class AddRealtyCityRefToRealty < ActiveRecord::Migration
  def change
    add_column :realties, :realty_city_id, :integer
    add_index :realties, :realty_city_id
  end
end
