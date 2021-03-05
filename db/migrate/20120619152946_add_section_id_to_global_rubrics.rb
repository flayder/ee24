class AddSectionIdToGlobalRubrics < ActiveRecord::Migration
  def change
    add_column :global_rubrics, :section_id, :integer
    add_index :global_rubrics, :section_id
  end
end
