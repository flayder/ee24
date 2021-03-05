class DeleteTypeColumnFromDictionaries < ActiveRecord::Migration
  def change
    remove_column :dictionary_rubrics, :dict_type
    remove_column :dictionary_objects, :type
  end
end
