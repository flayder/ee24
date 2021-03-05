class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string   "title"
      t.text     "text"
      t.string   "letter"
      t.boolean  "active",     :default => false
      t.boolean  "main",       :default => false
      t.string   "gender"
      t.string   "game"
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
