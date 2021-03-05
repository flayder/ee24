class AddImageToDictionaryObjects < ActiveRecord::Migration
  def change
    add_column :dictionary_objects, :image, :string
  end
end
