class RemoveSeoTextFromEventsDocsAndNewsDocs < ActiveRecord::Migration
  def change
    remove_column :events, :seo_text
    remove_column :docs, :seo_text
    remove_column :news_docs, :seo_text
  end
end
