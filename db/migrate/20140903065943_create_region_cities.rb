class CreateRegionCities < ActiveRecord::Migration
  def change
    create_table :region_cities do |t|
      t.string :title
      t.integer  :region_id

      t.timestamps
    end
    add_index :region_cities, :region_id
  end
end
