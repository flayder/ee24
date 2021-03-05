class AddInSitemapToSections < ActiveRecord::Migration
  def change
    add_column :sections, :in_sitemap, :boolean, default: false
  end
end
