class CreateDocRatings < ActiveRecord::Migration
  def self.up
    create_table :doc_ratings do |t|
      t.integer :user_id
      t.integer :ratable_id
      t.string  :ratable_type
      t.integer :value, :limit => 1
      t.timestamps
    end
    add_index :doc_ratings, :user_id
    add_index :doc_ratings, :ratable_id
  end

  def self.down
    drop_table :doc_ratings
  end
end
