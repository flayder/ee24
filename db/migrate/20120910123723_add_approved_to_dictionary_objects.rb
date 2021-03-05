class AddApprovedToDictionaryObjects < ActiveRecord::Migration
  def change
    add_column :dictionary_objects, :approved, :boolean, :default => false
  end
end
