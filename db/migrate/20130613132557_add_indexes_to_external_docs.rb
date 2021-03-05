class AddIndexesToExternalDocs < ActiveRecord::Migration
  def change
    add_index :external_docs, :site_id
    add_index :external_docs, :user_id
    add_index :external_docs, :external_doc_rubric_id
    add_index :external_doc_rubrics, :site_id
    add_index :external_docs, [:url, :site_id], unique: true
  end
end
