class CreateAdSurfaces < ActiveRecord::Migration
  def change
    create_table :ad_surfaces do |t|
      t.string :title, :default => ''
      t.text :description, :default => ''

      t.string :photo
      t.string :second_photo

      t.string :address, :default => ''
      t.string :latitude
      t.string :longitude

      t.integer :city_id
      t.integer :street_id
      t.integer :ad_agency_id
      t.integer :ad_format_id

      t.timestamps
    end
    add_index :ad_surfaces, :city_id
    add_index :ad_surfaces, :street_id
    add_index :ad_surfaces, :ad_agency_id
    add_index :ad_surfaces, :ad_format_id
  end
end
