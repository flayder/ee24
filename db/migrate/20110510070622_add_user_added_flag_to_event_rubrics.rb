class AddUserAddedFlagToEventRubrics < ActiveRecord::Migration
  def self.up
    add_column :event_rubrics, :user_added, :boolean, :default => false
  end

  def self.down
    remove_column :event_rubrics, :user_added
  end
end
