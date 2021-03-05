class RenameCatalog2SiteField < ActiveRecord::Migration
  def up
    rename_column :catalog2s, :site, :site_url
  end

  def down
    rename_column :catalog2s, :site_url, :site
  end
end
