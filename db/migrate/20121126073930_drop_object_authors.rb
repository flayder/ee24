class DropObjectAuthors < ActiveRecord::Migration
  def up
    drop_table :object_authors
  end

  def down
    create_table :object_authors do |t|
      t.string   :object_author_type
      t.integer  :object_author_id
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
