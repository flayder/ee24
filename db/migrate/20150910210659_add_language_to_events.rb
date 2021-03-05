class AddLanguageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :language, :string, default: 'ru'
  end
end
