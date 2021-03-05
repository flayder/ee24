class AddApprovedToNewsDocs < ActiveRecord::Migration
  def self.up
    add_column :news_docs, :approved, :boolean, :default => false
  end

  def self.down
    remove_column :news_docs, :approved
  end
end
