class AddUniqIndexToStatCounters < ActiveRecord::Migration
  def change
    add_index :stat_counters, :site_id
    add_index :stat_counters, [:model, :date, :site_id], :unique => true
  end
end
