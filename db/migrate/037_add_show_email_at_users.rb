class AddShowEmailAtUsers < ActiveRecord::Migration
  def self.up
    add_column( "users", "show_email" , :boolean)
  end

  def self.down
    remove_column("users", "show_email")
  end
end
