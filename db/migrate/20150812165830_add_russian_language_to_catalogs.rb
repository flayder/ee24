class AddRussianLanguageToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :russian_language, :boolean
  end
end
