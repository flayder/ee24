class KursMetall < ActiveRecord::Migration
  def self.up
    create_table "kurs_metalls", :force => true do |t|
      t.date     "date"
      t.integer  "code"
      t.float    "buy"
      t.float    "sell"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :kurs_metalls
  end
end
