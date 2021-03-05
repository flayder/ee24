class AddApprovedAtToReply < ActiveRecord::Migration
  def change
    add_column :replies, :approved_at, :datetime
  end
end
