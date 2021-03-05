class RemoveQuestionFieldsFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :is_question
  end
end
