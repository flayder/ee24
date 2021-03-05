class AddArchiveAtBoard < ActiveRecord::Migration
  def self.up
    add_column("boards", "archive", :boolean, :default => false)
  end

  def self.down
    remove_column("boards", "archive")
  end
end
