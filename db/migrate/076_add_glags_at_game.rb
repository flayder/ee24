class AddGlagsAtGame < ActiveRecord::Migration
  def self.up
    add_column("games", "team_1_flag", :string, :nil => true)
    add_column("games", "team_2_flag", :string, :nil => true)
  end

  def self.down
    remove_column("games", "team_1_flag")
    remove_column("games", "team_2_flag")
  end
end
