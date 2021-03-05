class CreateAstrostars < ActiveRecord::Migration
  def self.up
    create_table :astrostars do |t|
      t.integer :horoscope_id
      t.string :period
      t.string :name
      t.string :sign
      t.integer :sign_id
      t.datetime :actual_period_start
      t.datetime :actual_period_finish
      t.text :text
      t.date :date
    end
  end

  def self.down
    drop_table :astrostars
  end
end
