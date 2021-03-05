# encoding : utf-8
class Vacancy < ActiveRecord::Base
  include JobItem
  include WithUniqueText
  include WithModerationNotification
  include WithApproved
  include WithPageViews

  has_paper_trail

  validates :region_city, :region, :posted_at, presence: true
  validate :posted_at_limit
  validates_length_of(:company_name, within: 2..160, message: "должно быть от 2 до 160 символов")

  COMMON_FIELDS = [:photos_attributes, :text, :money, :busy, :title, :industry_id, :contacts_name, :contacts_email, :profession_ids, :company_name, :region_city_id,
                   :contacts_phone, :catalog_id, :region_id, :region_city_title, :terms, :requirements, :additional_info, :hot, :user_contacts, :currency, :posted_for,
                   :closed, :created_at]

  ADMIN_FIELDS = COMMON_FIELDS | [:user_id, :approved, :link, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  attr_accessor :region_city_title

  before_validation :set_region_city
  before_validation :set_posted_at

  belongs_to :region
  belongs_to :region_city
  belongs_to :catalog

  scope :approved, where(approved: true)
  scope :actual, where("posted_at >= ?", Time.current)
  scope :not_actual, where("posted_at < ?", Time.current)
  scope :not_closed, where(closed: false)
  scope :for_main, approved.actual.not_closed

  def url
    (Rails.env == 'production' ? 'https://' + Settings.portal_domain : '') + '/job/vacancies/' + self.id.to_s
  end

  #занятость для яндекса
  def yandex_busy
    if self.busy.present?
      ya_busy = {}
      if self.busy == 'full'
        ya_busy[:employment] = 'полная'
      elsif self.busy == 'free'
        ya_busy[:schedule] = 'гибкий'
      elsif self.busy == 'freelance'
        ya_busy[:schedule] = 'удалённая работа'
      end
      ya_busy unless ya_busy.empty?
    end
  end

  def posted_at_limit
    errors.add(:posted_at, "Превышена максимальная дата размещения") if posted_at && posted_at > (created_at || DateTime.now) + posted_for.days
  end

  private

  def set_region_city
    if !self.region_city_id? && self.region_city_title
      reg = Region.find(self.region_id)
      city = reg.cities.create(title: self.region_city_title)
      self.region_city = city
    end
  end

  def set_posted_at
    self.posted_at = (created_at || DateTime.now) + posted_for.days
  end

end
