class DropNames < ActiveRecord::Migration
  def up
    drop_table :names
  end

  def down
    create_table :names do |t|
      t.string   :title
      t.text     :text
      t.string   :letter
      t.boolean  :active,     :default => false
      t.boolean  :main,       :default => false
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :gender
    end
  end
end
