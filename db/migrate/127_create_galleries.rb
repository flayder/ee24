class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string   "title"
      t.string   "link"
      t.integer  "position"
      t.integer  "photo_global_rubric_id"
      t.integer  "city_id"
      t.boolean  "main"
      t.boolean  "active"
      t.boolean  "approved",             :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
