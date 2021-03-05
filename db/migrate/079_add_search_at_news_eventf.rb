class AddSearchAtNewsEventf < ActiveRecord::Migration
  def self.up
    add_column("events", "search", :string, :nil => true)
    add_column("news_docs", "search", :string, :nil => true)
  end

  def self.down
    remove_column("events", "search")
    remove_column("news_docs", "search")
  end
end
