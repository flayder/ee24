class AddDictionaryIdToDictionaryRubric < ActiveRecord::Migration
  def change
    add_column :dictionary_rubrics, :dictionary_id, :integer
    add_index :dictionary_rubrics, :dictionary_id
  end
end
