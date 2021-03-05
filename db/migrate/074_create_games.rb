class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string   "team1"
      t.string   "team2"
      t.string   "map"
      t.string   "hltv"
      t.boolean  "active", :default => false
      t.boolean  "main", :default => false
      t.datetime "start_date"
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
