class RenameNotInYandexRssDocFiledToNotInRss < ActiveRecord::Migration
  def change
    rename_column :docs, :not_in_yandex_rss, :not_in_rss
    rename_column :news_docs, :not_in_yandex_rss, :not_in_rss
  end
end
