class CreateRealtyPhotos < ActiveRecord::Migration
  def change
    create_table :realty_photos do |t|
      t.references :realty
      t.string :image

      t.timestamps
    end
    add_index :realty_photos, :realty_id
  end
end
