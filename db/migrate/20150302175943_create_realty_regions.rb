class CreateRealtyRegions < ActiveRecord::Migration
  def change
    create_table :realty_regions do |t|
      t.string :name

      t.timestamps
    end
  end
end
