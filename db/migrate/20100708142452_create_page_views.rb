class CreatePageViews < ActiveRecord::Migration
  def self.up
    create_table :page_views do |t|
      t.string  :url, :unique => true
      t.integer :count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :page_views
  end
end
