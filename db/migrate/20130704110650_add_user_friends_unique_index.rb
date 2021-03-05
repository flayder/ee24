class AddUserFriendsUniqueIndex < ActiveRecord::Migration
  def change
    add_index :users_friends, [:user_id, :friend_id], unique: true
  end
end
