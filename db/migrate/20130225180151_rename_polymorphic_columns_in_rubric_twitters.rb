class RenamePolymorphicColumnsInRubricTwitters < ActiveRecord::Migration
  def change
    rename_column :rubric_twitters, :rubric_id, :twittable_id
    rename_column :rubric_twitters, :rubric_type, :twittable_type
  end
end
