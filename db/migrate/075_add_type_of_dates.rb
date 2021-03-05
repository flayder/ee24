class AddTypeOfDates < ActiveRecord::Migration
  def self.up
    add_column("events", "since", :boolean, :default => false)
  end

  def self.down
    remove_column("events", "since")
  end
end
