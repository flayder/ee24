class AddPostLjToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :post_lj, :boolean, :default => false
  end

  def self.down
    remove_column :galleries, :post_lj
  end
end
