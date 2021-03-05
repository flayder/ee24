class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.text :answer
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
