class AddImageToDictionaryRubrics < ActiveRecord::Migration
  def change
    add_column :dictionary_rubrics, :image, :string
  end
end
