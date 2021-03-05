require 'progress_bar'

class CreateCatalogRubricCounters < ActiveRecord::Migration
  def up
    create_table :catalog_rubric_counters do |t|
      t.integer :catalog_rubric_id
      t.string  :language
      t.integer :counter, default: 0

      t.timestamps
    end
    add_index :catalog_rubric_counters, [:language]
  end

  def down
    drop_table :catalog_rubric_counters
  end
end
