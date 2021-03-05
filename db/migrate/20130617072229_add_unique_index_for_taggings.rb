class AddUniqueIndexForTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type], unique: true, name: :unique_taggings
  end
end
