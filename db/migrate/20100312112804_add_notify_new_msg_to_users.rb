class AddNotifyNewMsgToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_new_msg, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notify_new_msg
  end
end
