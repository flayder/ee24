class CreateFooterBlocks < ActiveRecord::Migration
  def change
    create_table :footer_blocks do |t|
      t.string :name
      t.string :identity
      t.text :content

      t.timestamps
    end
  end
end
