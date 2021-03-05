class AddUniqTitleIndexesToArticles < ActiveRecord::Migration
  def change
    add_index :docs, [:title, :site_id, :approved], :uniq => true
    add_index :news_docs, [:title, :site_id, :approved], :uniq => true
    add_index :events, [:title, :site_id, :approved], :uniq => true
  end
end
