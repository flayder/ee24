class AddFriends < ActiveRecord::Migration
  def self.up
    create_table :users_friends do |t|
      t.column :user_id,            :integer
      t.column :friend_id,          :integer
    end
  end

  def self.down
    drop_table :users_friends
  end
end
