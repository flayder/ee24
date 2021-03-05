class ModifyPageViews < ActiveRecord::Migration
  def self.up
    add_column :page_views, :year, :integer
    add_column :page_views, :month, :integer
    change_column :page_views, :url, :string, :unique => false
    add_index :page_views, [:url, :year, :month], :unique => true
  end

  def self.down
    remove_index :page_views, [:url, :year, :month]
    remove_column :page_views, :year
    remove_column :page_views, :month
  end
end
