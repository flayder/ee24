class AddApprovedAtComments < ActiveRecord::Migration
  def self.up
    add_column("comments", "approved", :boolean, :nil => false, :default => false)
  end

  def self.down
    remove_column("comments", "approved")
  end
end
