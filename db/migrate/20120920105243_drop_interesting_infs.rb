class DropInterestingInfs < ActiveRecord::Migration
  def up
    drop_table :interesting_infs
  end

  def down
    create_table :interesting_infs do |t|
      t.string   "title"
      t.text     "annotation"
      t.string   "doc_type"
      t.integer  "doc_id"
      t.string   "link"
      t.string   "image"
      t.timestamps
    end
    add_index :interesting_infs, :doc_id
  end
end
