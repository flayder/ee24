class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.string :title, :default => ''
      t.integer :city_id

      t.timestamps
    end
    add_index :streets, :city_id
  end
end
