class RemoveNewsDocType < ActiveRecord::Migration
  def up
    remove_column :news_docs, :news_doc_type
  end

  def down
    add_column :news_docs, :news_doc_type, :boolean
  end
end
