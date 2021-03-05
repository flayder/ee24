class ChangePartnersToHaveManyUsers < ActiveRecord::Migration
  def self.up
    remove_column :partners, :user_id
    create_table :partners_users, :id => false do |t|
      t.integer :partner_id
      t.integer :user_id
    end
  end

  def self.down
    add_column :partners, :user_id, :integer
    drop_table :partners_users
  end
end
