class AddYandexZenToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :yandex_zen, :boolean, default: false
  end
end
