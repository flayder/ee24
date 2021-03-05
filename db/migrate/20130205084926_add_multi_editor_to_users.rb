class AddMultiEditorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :multi_editor, :boolean, :default => false
  end
end
