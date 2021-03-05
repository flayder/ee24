class UpdateReplies < ActiveRecord::Migration
  def self.up
    add_column( "replies", "number" , :integer, {:null => false, :default => 1 })
  end

  def self.down
    remove_column("replies", "number")
  end
end