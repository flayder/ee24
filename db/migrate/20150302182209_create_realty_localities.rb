class CreateRealtyLocalities < ActiveRecord::Migration
  def change
    create_table :realty_localities do |t|
      t.string :name

      t.timestamps
    end
  end
end
