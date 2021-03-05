class AddViewsRatingToObjects < ActiveRecord::Migration
  def change
    add_column :news_docs, :views_rating, :integer, :default => 0
    add_column :docs, :views_rating, :integer, :default => 0
    add_column :events, :views_rating, :integer, :default => 0
    add_column :galleries, :views_rating, :integer, :default => 0
  end
end
