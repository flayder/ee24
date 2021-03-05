class RenameDescriptionToDescriptionFullOnRealties < ActiveRecord::Migration
  def change
    rename_column :realties, :description, :description_full
  end
end
