class AddSmallReportAtMenu < ActiveRecord::Migration
  def self.up
    add_column("menus", "small_report", :string)
  end

  def self.down
    remove_column("menus", "small_report")
  end
end
