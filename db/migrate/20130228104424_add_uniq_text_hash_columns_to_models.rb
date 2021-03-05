class AddUniqTextHashColumnsToModels < ActiveRecord::Migration
  def change
    add_column :boards, :text_hash, :string
    add_column :docs, :text_hash, :string
    add_column :events, :text_hash, :string
    add_column :news_docs, :text_hash, :string
    add_column :resumes, :text_hash, :string
    add_column :vacancies, :text_hash, :string
  end
end
