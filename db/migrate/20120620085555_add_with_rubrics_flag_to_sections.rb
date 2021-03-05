class AddWithRubricsFlagToSections < ActiveRecord::Migration
  def up
    add_column :sections, :with_rubrics, :boolean, :default => false
  end

  def down
    remove_column :sections, :with_rubrics
  end
end
