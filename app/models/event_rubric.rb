# encoding : utf-8
class EventRubric < ActiveRecord::Base
  include SeoValues
  include WithAd
  include WithSite
  include WithLink

  has_many :events, order: "created_at DESC"
  has_many :docs, class_name: :Event

  before_create :set_user_added
  before_create :set_position

  scope :user_added, where(user_added: true)
  scope :afisha_main, where(afisha_main: true).order('afisha_main_position ASC')
  scope :main, where(main: true)

  attr_accessible :title, :english_title, :image, :link, :main, :position, :afisha_main, :afisha_main_position, :description, :main_banner, as: :admin

  def main
    self[:main] ||= true
  end

  def set_user_added
    self.user_added = true
  end

  def title
    I18n.locale == :ru ? self.read_attribute(:title) : self.english_title
  end

  def url
    "/afisha/#{link}"
  end

  def set_position
    unless position?
      er = EventRubric.site(site_id).select('max(position) AS position').first if site_id?
      self.position = er.present? ? er.position.to_i+1 : 0
    end
  end
end
