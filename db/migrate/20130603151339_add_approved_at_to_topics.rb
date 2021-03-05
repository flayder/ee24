class AddApprovedAtToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :approved_at, :datetime
  end
end
