class AddTimeZoneToSites < ActiveRecord::Migration
  def change
    add_column :sites, :time_zone, :integer
  end
end
