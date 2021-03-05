class DropCounts < ActiveRecord::Migration
  def change
    drop_table :counts
  end
end
