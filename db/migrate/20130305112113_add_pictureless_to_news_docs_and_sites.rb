class AddPicturelessToNewsDocsAndSites < ActiveRecord::Migration
  def change
    add_column :news_docs, :pictureless, :boolean, :default => true
    add_column :sites, :pictureless, :boolean, :default => false
  end
end
