class CreateHoroscopeDailies < ActiveRecord::Migration
  def self.up
    create_table :horoscope_dailies do |t|
      t.column :text,                     :text
      t.column :date,                     :date
      t.timestamps
    end
  end

  def self.down
    drop_table :horoscope_dailies
  end
end
