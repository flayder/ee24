class CreateMetrikaApiAccountSearchQueries < ActiveRecord::Migration
  def change
    create_table :metrika_api_account_search_queries do |t|
      t.string :body
      t.integer :page_views
      t.integer :visits
      t.integer :url_id

      t.timestamps
    end
  end
end
