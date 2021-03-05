class RenameRubricDocs < ActiveRecord::Migration
  def up
    rename_table :rubric_docs, :doc_rubrics
    rename_column :docs, :rubric_doc_id, :rubric_id
  end

  def down
    rename_table :doc_rubrics, :rubric_docs
    rename_column :docs, :rubric_id, :rubric_doc_id
  end
end
