class RenameNewsToOldTables < ActiveRecord::Migration
  def self.up
    rename_table :news, "old_news"
  end

  def self.down
    rename_table "old_news", :news 
  end
end
