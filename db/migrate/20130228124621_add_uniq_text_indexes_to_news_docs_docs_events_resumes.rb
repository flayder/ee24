class AddUniqTextIndexesToNewsDocsDocsEventsResumes < ActiveRecord::Migration
  def change
    add_index :events, [:text_hash, :site_id], unique: true
    add_index :news_docs, [:text_hash, :site_id], unique: true
    add_index :docs, [:text_hash, :site_id], unique: true
    add_index :resumes, [:text_hash, :site_id], unique: true
    add_index :vacancies, [:text_hash, :site_id], unique: true
  end
end
