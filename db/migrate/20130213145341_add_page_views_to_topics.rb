class AddPageViewsToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :page_views, :integer, :default => 1
  end
end
