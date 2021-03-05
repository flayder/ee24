class CreateMetrikaApiAccounts < ActiveRecord::Migration
  def change
    create_table :metrika_api_accounts do |t|
      t.string :app_id
      t.string :app_password
      t.string :token
      t.integer :site_id, :null => false
      t.string :counter_id

      t.timestamps
    end

    add_index :metrika_api_accounts, :site_id
  end
end
