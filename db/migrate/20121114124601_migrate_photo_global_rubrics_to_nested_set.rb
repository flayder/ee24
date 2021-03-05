class MigratePhotoGlobalRubricsToNestedSet < ActiveRecord::Migration
  def up
    add_column :photo_global_rubrics, :with_rating, :boolean, :default => false
    add_column :photo_global_rubrics, :lft, :integer
    add_column :photo_global_rubrics, :rgt, :integer
  end

  def down
    remove_column :photo_global_rubrics, :with_rating
    remove_column :photo_global_rubrics, :lft
    remove_column :photo_global_rubrics, :rgt
  end
end
