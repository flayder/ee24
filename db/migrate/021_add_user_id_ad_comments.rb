class AddUserIdAdComments < ActiveRecord::Migration
  def self.up
    add_column("comments", "user_id", :integer, { :null => true })
    add_column("comments", "name", :string, { :null => true })
  end

  def self.down
    remove_column "comments", "user_id"
    remove_column "comments", "name"
  end
end
