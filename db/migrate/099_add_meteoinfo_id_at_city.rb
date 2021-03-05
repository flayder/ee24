class AddMeteoinfoIdAtCity < ActiveRecord::Migration
  def self.up
    add_column("cities", "meteoinfo_id", :integer)
  end

  def self.down
    remove_column("cities", "meteoinfo_id")
  end
end
