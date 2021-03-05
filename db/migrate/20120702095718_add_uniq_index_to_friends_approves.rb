class AddUniqIndexToFriendsApproves < ActiveRecord::Migration
  def change
    add_index :friends_approves, [:user_id, :friend_id], :unique => true
  end
end
