class CreateRequestForms < ActiveRecord::Migration
  def change
    create_table :request_forms do |t|
      t.string :full_name
      t.string :email
      t.string :phone_number
      t.date :birthday
      t.text :comment
      t.integer :docable_id
      t.string :docable_type
      t.timestamps
    end
  end
end
