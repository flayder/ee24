class AddPortalTitleAtCity < ActiveRecord::Migration
  def self.up
    add_column("cities", "portal_title", :string)
    add_column("cities", "domain", :string)
  end

  def self.down
    remove_column("cities", "portal_title")
    remove_column("cities", "domain")
  end
end
