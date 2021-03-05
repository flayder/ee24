class AddCityIdToAtms < ActiveRecord::Migration
  def change
    add_column :atms, :city_id, :integer
    add_index :atms, :city_id
  end
end
