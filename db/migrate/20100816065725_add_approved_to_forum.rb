class AddApprovedToForum < ActiveRecord::Migration
  def self.up
    add_column :topics, :approved, :boolean
    add_column :replies, :approved, :boolean
  end

  def self.down
    remove_column :topics, :approved
    remove_column :replies, :approved
  end
end
