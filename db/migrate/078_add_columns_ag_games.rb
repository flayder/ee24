class AddColumnsAgGames < ActiveRecord::Migration
  def self.up
    add_column("games", "title", :string, :nil => true)
    add_column("games", "online", :boolean, :nil => false, :default => false)
    add_column("games", "score_team1", :string, :nil => true)
    add_column("games", "score_team2", :string, :nil => true)
  end

  def self.down
    remove_column("games", "title")
    remove_column("games", "on-line")
    remove_column("games", "score_team1")
    remove_column("games", "score_team2")
  end
end
