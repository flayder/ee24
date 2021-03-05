class CreateContestParts < ActiveRecord::Migration
  def self.up
    create_table :contest_parts do |t|
      t.integer :contest_id
      t.integer :user_id
      t.text :text, :default => '', :null => false
      t.timestamps
    end
    add_index :contest_parts, :contest_id
    add_index :contest_parts, :user_id
  end

  def self.down
    drop_table :contest_parts
  end
end
