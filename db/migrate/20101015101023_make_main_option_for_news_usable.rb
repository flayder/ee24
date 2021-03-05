class MakeMainOptionForNewsUsable < ActiveRecord::Migration
  def self.up
    change_column :news_docs, :main, :boolean, :default => true
  end

  def self.down
    change_column :news_docs, :main, :boolean, :default => nil
  end
end
