class AddErrorPageCountToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :error_page_count, :integer, :default => 0, :limit => 8
  end

  def self.down
    remove_column :cities, :error_page_count
  end
end
