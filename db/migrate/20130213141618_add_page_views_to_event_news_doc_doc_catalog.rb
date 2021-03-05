class AddPageViewsToEventNewsDocDocCatalog < ActiveRecord::Migration
  def change
    add_column :docs, :page_views, :integer, :default => 1
    add_column :news_docs, :page_views, :integer, :default => 1
    add_column :catalogs, :page_views, :integer, :default => 1
    add_column :events, :page_views, :integer, :default => 1
  end
end