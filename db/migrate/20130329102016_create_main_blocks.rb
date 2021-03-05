class CreateMainBlocks < ActiveRecord::Migration
  def change
    create_table :main_blocks do |t|
      t.string :doc_type
      t.integer :site_id

      t.timestamps
    end

    add_index :main_blocks, :site_id
  end
end
