class AddPageViewsToGallery < ActiveRecord::Migration
  def change
    add_column :galleries, :page_views, :integer, :default => 1
  end
end
