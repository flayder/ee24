class AddLanguageToSeos < ActiveRecord::Migration
  def change
    add_column :seos, :language, :string, default: 'ru'
  end
end
