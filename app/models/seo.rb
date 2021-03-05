# encoding : utf-8
# sub_text - хранит доп. текст к определенному объекту
#   Используется, по крайней мере, в разделе Справка (напр.: "В этом разделе можно разместить информацию о журналах...").

class Seo < ActiveRecord::Base
  include WithSite
  belongs_to :seo, :polymorphic => true

  validates :site_id, :uniqueness => {:scope => [:seo_id, :seo_type]}, :if => :uniqueness_required?
  validates :site_id, :uniqueness => {:scope => [:seo_id, :seo_type, :path]}
  validate :size_of_news_keywords

  attr_accessible :site_id, :about, :title, :description, :keywords, :language, :seo_id, :seo_type, :path ,:text, :sub_text, :news_keywords, as: :admin

  scope :by_language, lambda { where(language: I18n.locale.to_s) }

  #seo для главных страниц может быть несколько
  def uniqueness_required?
    (self.seo_id? && self.seo_type?)
  end

  private
  def size_of_news_keywords
    errors.add(:news_keywords, "Должно быть не больше 10 слов (через запятую)") if news_keywords && news_keywords.split(',').size > 10
  end
end
