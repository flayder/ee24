class RefactorStatCounterColumns < ActiveRecord::Migration
  def change
    remove_column :stat_counters, :total_count
    rename_column :stat_counters, :today_count, :count
  end
end
