class CreateWeathers < ActiveRecord::Migration
  def self.up
    create_table :weathers do |t|
      t.integer :city_id
      t.date :date
      t.integer :temp_low
      t.integer :temp_high
      t.string :icon
      t.string :comment, :default => ''

      t.timestamps
    end
    add_index :weathers, :city_id
  end

  def self.down
    drop_table :weathers
  end
end
