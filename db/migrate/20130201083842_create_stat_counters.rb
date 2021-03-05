class CreateStatCounters < ActiveRecord::Migration
  def change
    create_table :stat_counters do |t|
      t.string :model
      t.integer :today_count
      t.integer :total_count
      t.date :date
      t.integer :site_id

      t.timestamps
    end
  end
end
