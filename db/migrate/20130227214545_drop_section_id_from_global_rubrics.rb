class DropSectionIdFromGlobalRubrics < ActiveRecord::Migration
  def change
    remove_column :global_rubrics, :section_id
  end
end
