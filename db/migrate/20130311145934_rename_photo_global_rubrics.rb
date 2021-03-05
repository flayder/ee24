class RenamePhotoGlobalRubrics < ActiveRecord::Migration
  def up
    rename_table :photo_global_rubrics, :photo_rubrics
    rename_column :galleries, :photo_global_rubric_id, :photo_rubric_id
  end

  def down
    rename_table :photo_rubrics, :photo_global_rubrics
    rename_column :galleries, :photo_rubric_id, :photo_global_rubric_id
  end
end
