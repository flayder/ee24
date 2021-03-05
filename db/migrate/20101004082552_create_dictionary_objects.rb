class CreateDictionaryObjects < ActiveRecord::Migration
  def self.up
    create_table :dictionary_objects do |t|
      t.string :title
      t.text :text
      t.string :letter, :limit => 5
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :dictionary_objects
  end
end
