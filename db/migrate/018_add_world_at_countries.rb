class AddWorldAtCountries < ActiveRecord::Migration
  def self.up
    add_column("countries", "world", :string, { :null => true })
  end

  def self.down
    remove_column("countries", "world")
  end
end
