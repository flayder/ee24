class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :logo
      t.integer :category_id
      t.text :description
      t.text :rules
      t.integer :user_id
      t.boolean :banned, default: false

      t.timestamps
    end
  end
end
