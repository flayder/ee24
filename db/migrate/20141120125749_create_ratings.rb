class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :rateable_id
      t.string :rateable_type
      t.integer :user_id
      t.boolean :positive, default: false

      t.timestamps
    end
  end
end
