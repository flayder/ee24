class CreateDictionaryRubrics < ActiveRecord::Migration
  def self.up
    create_table :dictionary_rubrics do |t|
      t.string :title, :null => false, :default => ''
      t.string :dict_type
      
      t.timestamps
    end
    add_column :dictionary_objects, :rubric_id, :integer
    add_index  :dictionary_objects, :rubric_id
  end

  def self.down
    drop_table :dictionary_rubrics
    remove_column :dictionary_objects, :rubric_id
  end
end
