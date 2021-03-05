class AddUrlAtBanners < ActiveRecord::Migration
  def self.up
    add_column :banners, :url, :string, :nil => false
  end

  def self.down
    remove_column :banners, :url
  end
end
