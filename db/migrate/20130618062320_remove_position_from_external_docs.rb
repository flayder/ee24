class RemovePositionFromExternalDocs < ActiveRecord::Migration
  def up
    remove_column :external_docs, :position
  end

  def down
    add_column :external_docs, :position, :integer
  end
end
