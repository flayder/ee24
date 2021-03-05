class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string   "title"
      t.string   "link"
    end
  end

  def self.down
    drop_table :cities
  end
end
