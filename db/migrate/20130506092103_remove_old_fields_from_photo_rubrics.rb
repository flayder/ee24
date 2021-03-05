class RemoveOldFieldsFromPhotoRubrics < ActiveRecord::Migration
  def up
    change_table(:photo_rubrics) do |t|
      t.remove :parent_id
      t.remove :lft
      t.remove :rgt
    end
  end

  def down
    change_table(:photo_rubrics) do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end
  end
end
