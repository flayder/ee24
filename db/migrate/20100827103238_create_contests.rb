class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :title, :sponsor_image, :prize_title, :prize_image
      t.datetime :start, :finish
      t.integer :topic_id
      t.timestamps
    end
    add_index :contests, :topic_id
  end

  def self.down
    drop_table :contests
  end
end
