class AddSkipBannerToDocs < ActiveRecord::Migration
  def self.up
    add_column :docs, :skip_banner, :boolean, :default => false
  end

  def self.down
    remove_column :docs, :skip_banner, :boolean, :default => false
  end
end
