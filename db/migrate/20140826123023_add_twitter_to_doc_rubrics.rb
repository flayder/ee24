class AddTwitterToDocRubrics < ActiveRecord::Migration
  def change
    add_column :doc_rubrics, :twitter, :boolean, default: false
  end
end
