class DefaultApprovedForTopics < ActiveRecord::Migration
  def change
    change_column_default :topics, :approved, false
  end
end
