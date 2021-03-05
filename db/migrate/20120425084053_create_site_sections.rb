class CreateSiteSections < ActiveRecord::Migration
  def change
    create_table :site_sections do |t|
      t.integer :site_id
      t.integer :section_id

      t.timestamps
    end
    add_index :site_sections, :site_id
    add_index :site_sections, :section_id
  end
end
