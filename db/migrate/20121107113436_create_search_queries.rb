class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.string :query
      t.integer :site_id

      t.timestamps
    end

    add_index :search_queries, :site_id
  end
end
