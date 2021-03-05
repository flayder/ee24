require 'progress_bar'

class CreateCatalogDescription < ActiveRecord::Migration
  def up
    create_table :catalog_descriptions do |t|
      t.integer :catalog_id
      t.string  :language

      t.string  :title
      t.text    :annotation
      t.text    :text

      t.timestamps
    end
    add_index :catalog_descriptions, [:language]
  end

  def down
    drop_table :catalog_descriptions
  end
end
