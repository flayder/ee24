class AddNotificationsSentAtToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :notifications_sent_at, :datetime
  end
end
