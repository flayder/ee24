class AddLogoAltPageTitleAtCatalog < ActiveRecord::Migration
  def self.up
    add_column("catalogs", "logo_alt", :string)
    add_column("catalogs", "page_title", :string)
  end

  def self.down
    remove_column("catalogs", "logo_alt")
    remove_column("catalogs", "page_title")
  end
end
