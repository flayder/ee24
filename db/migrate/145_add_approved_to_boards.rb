class AddApprovedToBoards < ActiveRecord::Migration
  def self.up
    add_column("boards", "approved", :boolean, :nil => false, :default => false)
  end

  def self.down
    remove_column("boards", "approved")
  end
end
