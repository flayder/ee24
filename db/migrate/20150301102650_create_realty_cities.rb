class CreateRealtyCities < ActiveRecord::Migration
  def change
    create_table :realty_cities do |t|
      t.string :name

      t.timestamps
    end
  end
end
