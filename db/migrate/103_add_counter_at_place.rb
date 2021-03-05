class AddCounterAtPlace < ActiveRecord::Migration
  def self.up
    add_column("places", "popularity", :integer, :nil => false, :default => 0)
  end

  def self.down
    remove_column("places", "popularity")
  end
end
