class UpdateUsersTable < ActiveRecord::Migration
  def self.up
    rename_column "users", "real_name", "fio"
    add_column "users", "birth", :date
    add_column "users", "academic", :string, { :null => true }
    add_column "users", "show_icq", :boolean
    add_column "users", "show_skype", :boolean
    add_column "users", "confirmation_token", :string, { :null => true }
    add_column "users", "confirm", :boolean
  end

  def self.down
    rename_column "users", "fio", "real_name"
    remove_column "users", "birth"
    remove_column "users", "academic"
    remove_column "users", "show_icq"
    remove_column "users", "show_skype"
    remove_column "users", "confirmation_token"
    remove_column "users", "confirm"
  end
end
