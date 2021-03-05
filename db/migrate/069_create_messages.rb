class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string   "title"
      t.text     "text"
      t.integer  "user_id"
      t.integer  "sender_id"
      t.boolean  "admin", :default => false
      t.boolean  "viewed", :default => false
      t.string   "buttons"
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
