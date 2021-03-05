class AddPositionToDocGlobalRubric < ActiveRecord::Migration
  def change
    add_column :doc_global_rubrics, :position, :integer
    add_index :doc_global_rubrics, :position
  end
end
