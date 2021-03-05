class AddOnMainAndBlacklistToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :on_main, :boolean, :default => false
    add_column :topics, :blacklist, :boolean, :default => false
  end
end
