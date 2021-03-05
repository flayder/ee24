class AddUniqEmailConstraintToUser < ActiveRecord::Migration
  def change
    add_index :users, [:email, :site_id], :unique => true
    add_index :users, [:subdomain, :site_id], :unique => true
  end
end
