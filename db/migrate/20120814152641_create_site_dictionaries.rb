class CreateSiteDictionaries < ActiveRecord::Migration
  def self.up
    create_table :site_dictionaries do |t|
      t.column :site_id, :integer, :null => false
      t.column :dictionary_type, :string, :null => false
      t.timestamps
    end

    add_index :site_dictionaries, :site_id
    add_index :site_dictionaries, [:site_id, :dictionary_type], :uniq => true
  end

  def self.down
    remove_index :site_dictionaries, :site_id
    remove_index :site_dictionaries, [:site_id, :dictionary_type]
    drop_table :site_dictionaries
  end
end