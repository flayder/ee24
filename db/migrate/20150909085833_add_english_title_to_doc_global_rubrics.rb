class AddEnglishTitleToDocGlobalRubrics < ActiveRecord::Migration
  def change
    add_column :doc_global_rubrics, :english_title, :string
    add_column :doc_rubrics, :english_title, :string

    DocGlobalRubric.all.each do |global_rubric|
      global_rubric.update_attribute(:english_title, Russian::translit(global_rubric.title))
    end

    DocRubric.all.each do |rubric|
      rubric.update_attribute(:english_title, Russian::translit(rubric.title))
    end
  end
end
