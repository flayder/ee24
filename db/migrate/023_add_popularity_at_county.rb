class AddPopularityAtCounty < ActiveRecord::Migration
  def self.up
    add_column("countries", "popularity", :integer, { :null => false, :default => 0 })
  end

  def self.down
    remove_column "countries", "popularity"
  end
end
