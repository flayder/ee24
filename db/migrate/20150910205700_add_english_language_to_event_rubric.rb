class AddEnglishLanguageToEventRubric < ActiveRecord::Migration
  def change
    add_column :event_rubrics, :english_title, :string

    EventRubric.all.each do |rubric|
      rubric.update_attribute(:english_title, Russian::translit(rubric.title))
    end
  end
end
