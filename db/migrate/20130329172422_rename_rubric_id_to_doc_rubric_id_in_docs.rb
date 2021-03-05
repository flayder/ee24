class RenameRubricIdToDocRubricIdInDocs < ActiveRecord::Migration
  def change
    rename_column :docs, :rubric_id, :doc_rubric_id
  end
end
