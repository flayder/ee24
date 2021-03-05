class DropNewsDocsAndNewsRubrics < ActiveRecord::Migration
  def change
    drop_table :news_docs
    drop_table :news_rubrics
  end
end
