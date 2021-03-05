class AddShortTitleToSites < ActiveRecord::Migration
  def up
    add_column :sites, :short_title, :string, :default => ''
  end

  def down
    remove_column :sites, :short_title
  end
end
