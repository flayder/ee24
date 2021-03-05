class DropPageViews < ActiveRecord::Migration
  def change
    drop_table :page_views
  end
end
