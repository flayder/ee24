class AddReportAtMenu < ActiveRecord::Migration
  def self.up
    add_column("menus", "report", :string)
  end

  def self.down
    remove_column("menus", "report")
  end
end
