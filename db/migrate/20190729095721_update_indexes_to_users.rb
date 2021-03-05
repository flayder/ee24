class UpdateIndexesToUsers < ActiveRecord::Migration
  def up
    remove_index :users, [:email, :site_id]
    add_index :users, :email
  end

  def down
    remove_index :users, :email
    add_index :users, [:email, :site_id], unique: true
  end
end
