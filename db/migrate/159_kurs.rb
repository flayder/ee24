class Kurs < ActiveRecord::Migration
  def self.up
    create_table "kurs", :force => true do |t|
      t.string  "charcode"
      t.string  "numcode"
      t.integer "nominal"
      t.string  "name"
      t.string  "value"
      t.date    "date"
    end
  end

  def self.down
    drop_table :kurs
  end
end
