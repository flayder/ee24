class CreateSiteRubrics < ActiveRecord::Migration
  def change
    create_table :site_rubrics do |t|
      t.references :site_section
      t.references :rubric, :polymorphic => true

      t.timestamps
    end
    add_index :site_rubrics, :site_section_id
    add_index :site_rubrics, :rubric_id
  end
end
