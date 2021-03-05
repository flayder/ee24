class RemoveBlock < ActiveRecord::Migration
  def self.up
    drop_table :blocks
  end

  def self.down
    create_table :blocks do |t|
    end
  end
end
