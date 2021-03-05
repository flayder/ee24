class AddWithRatingOptionToCatalogs < ActiveRecord::Migration
  def self.up
    add_column :catalog2s, :with_rating, :boolean, :default => true
  end

  def self.down
    remove_column :catalog2s, :with_rating
  end
end