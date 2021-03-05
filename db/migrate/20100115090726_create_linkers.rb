class CreateLinkers < ActiveRecord::Migration
  def self.up
    create_table :linkers do |t|
      t.string :url, :nil => true, :default => nil
      t.integer :counter, :nil => false, :default => 0
      t.text :seo_text
      t.timestamps
    end
  end

  def self.down
    drop_table :linkers
  end
end
