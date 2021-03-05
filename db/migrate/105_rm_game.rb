class RmGame < ActiveRecord::Migration
  def self.up
    drop_table :games
  end

  def self.down
    create_table :games do |t|
      t.timestamps
    end
  end
end
