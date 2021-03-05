class AddOldModelAndOldIdToDictionaryObjects < ActiveRecord::Migration
  def change
    add_column :dictionary_objects, :old_model, :string
    add_column :dictionary_objects, :old_id, :integer
  end
end
