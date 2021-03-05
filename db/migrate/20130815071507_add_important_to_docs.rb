class AddImportantToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :important, :boolean, default: false
  end
end
