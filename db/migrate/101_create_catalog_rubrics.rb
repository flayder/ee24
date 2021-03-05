class CreateCatalogRubrics < ActiveRecord::Migration
  def self.up
    create_table :catalog_rubrics do |t|
      t.column :catalog_id,                     :integer
      t.column :rubric_id,                      :integer
      t.timestamps
    end
    
    remove_column("catalog_rubrics", "id")
  end

  def self.down
    drop_table :catalog_rubrics
  end
end
