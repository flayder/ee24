class AddRobotsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :robots, :text
  end
end
