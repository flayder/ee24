class RemoveUrlNameFromExternalDoc < ActiveRecord::Migration
  def up
    remove_column :external_docs, :url_name
  end

  def down
    add_column :external_docs, :url_name, :string
  end
end
