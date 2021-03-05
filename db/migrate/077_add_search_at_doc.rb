class AddSearchAtDoc < ActiveRecord::Migration
  def self.up
    add_column("docs", "search", :string, :nil => true)
  end

  def self.down
    remove_column("docs", "search")
  end
end
