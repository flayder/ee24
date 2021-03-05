class CreateRealties < ActiveRecord::Migration
  def change
    create_table :realties do |t|
      t.integer :record_id
      t.string :address
      t.float :lat
      t.float :lng
      t.integer :price_cents
      t.string :currency
      t.float :total_area
      t.float :area_living
      t.integer :floor
      t.text :description
      t.text :base_description_full
      t.text :base_description_short
      t.integer :rooms_total
      t.integer :rooms_living
      t.integer :bedrooms
      t.boolean :balkony
      t.string :state

      t.timestamps
    end
  end
end
