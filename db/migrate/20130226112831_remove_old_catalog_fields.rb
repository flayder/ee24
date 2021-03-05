class RemoveOldCatalogFields < ActiveRecord::Migration
  def up
    remove_column :catalogs, :star
    remove_column :catalogs, :up
    remove_column :catalogs, :directory
    remove_column :catalogs, :page_title
  end

  def down
    add_column :catalogs, :star, :boolean
    add_column :catalogs, :up, :boolean
    add_column :catalogs, :directory, :boolean
    add_column :catalogs, :page_title, :string
  end
end
