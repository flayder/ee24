class AddLanguageToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :language, :string, default: 'ru'
  end
end
