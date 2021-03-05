class AddApprovedToDocs < ActiveRecord::Migration
  def self.up
    add_column :docs, :approved, :boolean, :default => false
  end

  def self.down
    remove_column :docs, :approved
  end
end
