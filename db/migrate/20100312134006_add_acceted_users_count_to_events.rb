class AddAccetedUsersCountToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :accepted_users_count, :integer, :default => 0
  end

  def self.down
    remove_column :events, :accepted_users_count
  end
end
