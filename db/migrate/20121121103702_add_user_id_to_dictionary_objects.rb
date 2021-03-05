class AddUserIdToDictionaryObjects < ActiveRecord::Migration
  def change
    add_column :dictionary_objects, :user_id, :integer
    add_index :dictionary_objects, :user_id
  end
end
