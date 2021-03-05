class AddNotInYandexRssFlagToDocs < ActiveRecord::Migration
  def change
    add_column :news_docs, :not_in_yandex_rss, :boolean, :default => false
    add_column :docs, :not_in_yandex_rss, :boolean, :default => false
  end
end
