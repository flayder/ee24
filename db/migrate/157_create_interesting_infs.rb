class CreateInterestingInfs < ActiveRecord::Migration
  def self.up
    create_table :interesting_infs do |t|
      t.string   "title"
      t.text     "annotation"
      t.string   "doc_type"
      t.integer  "doc_id"
      t.string   "link"
      t.string   "image"
      t.timestamps
    end
  end

  def self.down
    drop_table :interesting_infs
  end
end
