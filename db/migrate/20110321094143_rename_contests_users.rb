class RenameContestsUsers < ActiveRecord::Migration
  def self.up
    rename_table :contests_users, :contests_winners
  end

  def self.down
    rename_table :contests_winners, :contests_users
  end
end
