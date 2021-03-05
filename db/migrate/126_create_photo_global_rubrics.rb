class CreatePhotoGlobalRubrics < ActiveRecord::Migration
  def self.up
    create_table :photo_global_rubrics do |t|
      t.string   "title"
      t.string   "link"
      t.integer  "position"
      t.integer  "parent_id"
      t.boolean  "main"
      t.boolean  "active"
      t.boolean  "approved",             :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_global_rubrics
  end
end
