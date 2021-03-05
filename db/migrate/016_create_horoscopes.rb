class CreateHoroscopes < ActiveRecord::Migration
  def self.up
    create_table :horoscopes do |t|
      t.column :common,                       :string
      t.column :period_type,                         :string
      t.column :horoscope_type_id,            :integer
      t.column :symbol_1,                            :text
      t.column :symbol_2,                            :text
      t.column :symbol_3,                            :text
      t.column :symbol_4,                            :text
      t.column :symbol_5,                            :text
      t.column :symbol_6,                            :text
      t.column :symbol_7,                            :text
      t.column :symbol_8,                            :text
      t.column :symbol_9,                            :text
      t.column :symbol_10,                           :text
      t.column :symbol_11,                           :text
      t.column :symbol_12,                           :text
      t.column :period_date,                         :date
      t.column :to,                           :date
      t.column :active,                       :boolean, :default => false, :nil => false
      t.column :main,                         :boolean, :default => false, :nil => false
      t.column :link,                         :string
      t.timestamps
    end
  end

  def self.down
    drop_table :horoscopes
  end
end
