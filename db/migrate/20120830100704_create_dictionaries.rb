class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :link, :null => false
      t.integer :site_id, :null => false
      t.text :description
      t.string :title, :null => false

      t.timestamps
    end

    add_index :dictionaries, :site_id
  end
end