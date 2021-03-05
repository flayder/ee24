# encoding : utf-8
require 'file_size_validator'
class Event < ActiveRecord::Base
  include WithSite
  include WithPageViews
  include WithParam
  include WithMainPhoto
  include RatableDoc
  include WithLastUpdatedCache
  include WithUniqueText
  include Tagged
  include WithSimilarDocs
  include WithApproved
  include WithModerationNotification
  include Cacheable
  include WithMain
  include WithPreviewSecret

  has_paper_trail

  validates_presence_of :title, :text, :event_rubric_id, :start_date, :finish_date, :param, :site_id

  validates :site, :presence => true

  belongs_to :user
  belongs_to :rubric, :class_name => "EventRubric", :foreign_key => "event_rubric_id"
  has_many :ips, :as => :ip_object, :dependent => :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  scope :current, lambda {|date| where("DATE(finish_date) >= ? AND DATE(start_date) <= ?", date, date) }
  scope :current_or_future, lambda {|date| where("DATE(finish_date) >= ?", date) }
  scope :past, lambda { where("DATE(finish_date) < ?", Date.today) }
  scope :main, lambda { where(main: true) }

  scope :by_language, lambda { where(language: I18n.locale.to_s) }

  COMMON_FIELDS = [:event_rubric_id, :title, :language, :start_date, :finish_date, :annotation, :text, :photos_attributes, :created_at, :long_image, :address, :place]
  ADMIN_FIELDS = COMMON_FIELDS | [:approved, :gallery_author, :tag_list, :meta_title, :meta_description, :meta_keywords, :site_id, :main, :about, :user_id,
                                  :is_commentable, :site_url, :price, :promote_link, :show_time, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  def self.last_updated
    order('updated_at').last
  end

  def url(site = nil, domain = nil)
    if self.rubric.present?
      host = Rails.env == 'production' ? "#{Settings['default_protocol']}://#{Settings['default_host_name']}" : ''
      host + '/afisha/' + (self.param.present? ? self.rubric.link : 'show_event') + '/' + self.to_param
    else
      ''
    end
  end

  def link
    "/afisha/#{self.rubric.link}/#{self.id}-#{self.param}"
  end

  def comments_url(site = nil, domain = nil)
    "/afisha/#{self.rubric.link}/#{self.id}/comments"
  end

end
