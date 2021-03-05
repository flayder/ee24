class AddEnglishTitleToCatalogRubrics < ActiveRecord::Migration
  def change
    add_column :catalog_rubrics, :english_title, :string
  end
end
