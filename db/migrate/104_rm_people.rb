class RmPeople < ActiveRecord::Migration
  def self.up
    drop_table :people
  end

  def self.down
    create_table :people do |t|
      t.timestamps
    end
  end
end
