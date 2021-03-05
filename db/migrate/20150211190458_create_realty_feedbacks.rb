class CreateRealtyFeedbacks < ActiveRecord::Migration
  def change
    create_table :realty_feedbacks do |t|
      t.string :name
      t.string :phone_number
      t.boolean :urgent_call
      t.string :email
      t.text :body
      t.references :realty

      t.timestamps
    end
    add_index :realty_feedbacks, :realty_id
  end
end
