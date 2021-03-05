class RemoveImageFromDocsAndSo < ActiveRecord::Migration
  def up
  	remove_column :docs, :image
  	remove_column :news_docs, :image
  	remove_column :events, :image
  end

  def down
  	add_column :docs, :string
  	add_column :news_docs, :string
  	add_column :events, :string
  end
end
