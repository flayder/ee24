class AddSiteIdToDictionaryObjectsAndDictionaryRubrics < ActiveRecord::Migration
  def change
    add_column :dictionary_objects, :site_id, :integer
    add_column :dictionary_rubrics, :site_id, :integer
    add_index :dictionary_objects, :site_id
    add_index :dictionary_rubrics, :site_id
  end
end
