class CreateMainBlockRubrics < ActiveRecord::Migration
  def change
    create_table :main_block_rubrics do |t|
      t.integer :main_block_id
      t.integer :rubric_id
      t.string :rubric_type

      t.timestamps
    end

    add_index :main_block_rubrics, [:main_block_id, :rubric_id, :rubric_type], unique: true, name: 'main_block_rubrics_unique_main_blocks_rubrics'
  end
end
