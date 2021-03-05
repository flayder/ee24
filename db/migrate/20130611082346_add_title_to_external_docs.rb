class AddTitleToExternalDocs < ActiveRecord::Migration
  def change
    add_column :external_docs, :title, :string
  end
end
