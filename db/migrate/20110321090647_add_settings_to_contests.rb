class AddSettingsToContests < ActiveRecord::Migration
  def self.up
    change_table :contests do |t|
      t.integer :part_photos_count, :default => 0, :null => false
      t.boolean :part_text, :default => false
    end
  end

  def self.down
    change_table :contests do |t|
      t.remove :part_photos_count
      t.remove :part_text
    end
  end
end
