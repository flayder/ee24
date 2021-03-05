class CreateObjectAuthors < ActiveRecord::Migration
  def self.up
    create_table :object_authors do |t|
      t.string   "model"
      t.integer  "model_id"
      t.integer  "user_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :object_authors
  end
end
