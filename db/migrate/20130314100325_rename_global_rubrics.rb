class RenameGlobalRubrics < ActiveRecord::Migration
  def up
    rename_table :global_rubrics, :doc_global_rubrics
  end

  def down
    rename_table :doc_global_rubrics, :global_rubrics
  end
end
