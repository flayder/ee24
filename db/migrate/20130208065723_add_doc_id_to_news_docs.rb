class AddDocIdToNewsDocs < ActiveRecord::Migration
  def change
    add_column :news_docs, :doc_id, :integer
  end
end
