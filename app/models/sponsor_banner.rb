# encoding : utf-8
# TODO: Remove this model


class SponsorBanner < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include WithSite

  mount_uploader :image, ImageUploader

  COMMON_FIELDS = []
  ADMIN_FIELDS = COMMON_FIELDS | [:title, :start_date, :finish_date, :link, :url, :image, :image_cache, :remove_image, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  LINKS = [
            ["Новости:Все новости", "news"],
            ["Новости:Экономика", "news/economics"],
            ["Новости:Политика", "news/politics"],
            ["Новости:Общество", "news/people"],
            ["Новости:Спорт", "news/sport"],
            ["Новости:Культура", "news/culture"],
            ["Новости:Воронежский курьер", "news/v-kurier"],
            ["Новости:Интервью", "news/interview"],
            ["Новости:Авторские колонки", "news/auth-columns"],
            ["Недвижимость", "realty"],
            ["Афиша:Все события", "afisha"],
            ["Афиша:Кино", "afisha/cinema"],
            ["Афиша:Музыка", "afisha/music"],
            ["Афиша:Шоу", "afisha/show"],
            ["Афиша:Выставки", "afisha/exhibition"],
            ["Афиша:Вечеринки", "afisha/party"],
            ["Афиша:Бизнес", "afisha/business"],
            ["Афиша:Театр", "afisha/theatre"],
            ["Афиша:Спорт", "afisha/sport"],
            ["Афиша:Киберспорт", "afisha/cybersport"],
            ["Афиша:Конкурсы", "afisha/competitions"],
            ["Здоровье:Все статьи", "health"],
            ["Здоровье:Ждем ребенка", "health/baby"],
            ["Здоровье:Дети", "health/children"],
            ["Здоровье:Образ жизни", "health/life-style"],
            ["Здоровье:Алт медицина", "health/alt-medicine"],
            ["Здоровье:Диеты", "health/diet"],
            ["Журнал:Все статьи", "magazine"],
            ["Журнал:Стиль", "magazine/style"],
            ["Журнал:Эзотерика", "magazine/esotericism"],
            ["Журнал:Гадания", "magazine/palmistry"],
            ["Журнал:Фэн-шуй", "magazine/fs"],
            ["Журнал:Приметы", "magazine/tokens"],
            ["Журнал:Губерния", "magazine/province"],
            ["Журнал:Мир часов", "magazine/watch"],
            ["Отдых:Все статьи", "travel"],
            ["Отдых:Юридические вопросы", "travel/questions"],
            ["Отдых:Советы туристу", "travel/for-tourists"],
            ["Отдых:Образование за границей", "travel/teaching"],
            ["Киберспорт:Все статьи", "deathfish"],
            ["Киберспорт:Новости", "deathfish/news"],
            ["Киберспорт:Интервью", "deathfish/interview"],
            ["Киберспорт:Игры", "deathfish/deathfish_games"],
            ["Киберспорт:Deathfish", "deathfish/deathfish"],
            ["Киберспорт:Team46", "deathfish/team46"],
            ["Киберспорт:Npcl", "deathfish/npcl"],
            ["Киберспорт:Клубы", "deathfish/clubs"],
            ["Шоппинг:Все статьи", "shopping"],
            ["Шоппинг:Новости", "shopping/shopping_news"],
            ["Шоппинг:Оплата", "shopping/payment"],
            ["Шоппинг:Доставка", "shopping/delivery"],
            ["Шоппинг:Магазины", "shopping/shops"],
            ["Шоппинг:Правила покупок", "shopping/rules_shopping"],
            ["Шоппинг:Посредники", "shopping/mediators"],
            ["Шоппинг:Выбор одежды", "shopping/choice"]
          ]
end