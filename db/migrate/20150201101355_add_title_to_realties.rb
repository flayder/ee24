class AddTitleToRealties < ActiveRecord::Migration
  def change
    add_column :realties, :title, :string
  end
end
