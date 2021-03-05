class AddLinkIndexToDocGlobalRubrics < ActiveRecord::Migration
  def change
    add_index :doc_global_rubrics, :link
  end
end
