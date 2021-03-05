class AddPositionToDocRubrics < ActiveRecord::Migration
  def change
    add_column :doc_rubrics, :position, :integer
  end
end
