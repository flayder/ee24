class AddBannedToReply < ActiveRecord::Migration
  def change
    add_column :replies, :banned, :boolean, :default => false
  end
end
