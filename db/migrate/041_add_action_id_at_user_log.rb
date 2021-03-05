class AddActionIdAtUserLog < ActiveRecord::Migration
  def self.up
    add_column("user_logs", "action", :string)
    add_column("user_logs", "object_id", :integer)
  end

  def self.down
    remove_column("user_logs", "action")
    remove_column("user_logs", "object_id")
  end
end
