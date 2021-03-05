class AddEnglishNameToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :english_name, :string

    Category.all.each do |category|
      category.update_attribute(:english_name, Russian::translit(category.name))
    end
  end
end
