class CreateHoroscopeTypes < ActiveRecord::Migration
  def self.up
    create_table :horoscope_types do |t|
      t.column :title,            :string
      t.column :active,           :boolean, :default => false, :nil => false
      t.column :main,             :boolean, :default => false, :nil => false
      t.column :link,             :string
      t.timestamps
    end
  end

  def self.down
    drop_table :horoscope_types
  end
end
