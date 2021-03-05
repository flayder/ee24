class AddUniqIndexesToModelsWithParam < ActiveRecord::Migration
  def change
    add_index :docs, [:param, :site_id], :uniq => true
    add_index :news_docs, [:param, :site_id], :uniq => true
    add_index :events, [:param, :site_id], :uniq => true
  end
end
