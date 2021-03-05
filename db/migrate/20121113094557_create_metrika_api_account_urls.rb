class CreateMetrikaApiAccountUrls < ActiveRecord::Migration
  def change
    create_table :metrika_api_account_urls do |t|
      t.string :body
      t.integer :metrika_api_account_id
      t.timestamps
    end

    add_index :metrika_api_account_urls, :metrika_api_account_id
  end
end
