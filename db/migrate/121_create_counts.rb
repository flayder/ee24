class CreateCounts < ActiveRecord::Migration
  def self.up
    create_table :counts, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
      t.integer   "counter", :default => 0, :nil => false

      t.integer   "count_id"
      t.string    "count_type"
      t.integer   "city_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :counts
  end
end
