# encoding : utf-8
require 'file_size_validator'
class Doc < ActiveRecord::Base
  include WithSite
  include WithPageViews
  include WithParam
  include WithMainPhoto
  include RatableDoc
  include WithLastUpdatedCache
  include Tagged
  include WithUniqueText
  include WithSimilarDocs
  include WithApproved
  include WithModerationNotification
  include WithPreviewSecret
  include Cacheable
  include WithMain

  has_paper_trail

  belongs_to :rubric, :class_name => 'DocRubric', :foreign_key => :doc_rubric_id
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  validates_presence_of :title, :text, :doc_rubric_id, :site_id, :param, :user, :created_at
  validate :approve_on_correct
  delegate :global_rubric, :global_rubric_id, :to => :rubric

  scope :news, where(:doc_rubric_id => DocGlobalRubric.where(site_id: 93, link: 'news').first.try(:doc_rubrics).try(:map, &:id), :approved => true, :site_id => 93)
  scope :auth_columns_and_interviews, where(:doc_rubric_id => [DocRubric::INTERVIEW_ID, DocRubric::AUTH_COLUMNS_ID], :approved => true)

  scope :for_news_rss, joins(rubric: :global_rubric).where(doc_global_rubrics: { link: 'news' })
  scope :for_rss, where(not_in_rss: false).approved
  scope :date_between_weak, lambda { |range| where('created_at >= ? AND created_at <= ?', range.first, range.last) }
  scope :date_between_strict, lambda { |range| where('created_at > ? AND created_at < ?', range.first, range.last) }
  scope :date_between, lambda { |range, type| type == true ? date_between_weak(range) : date_between_strict(range) }
  scope :global_rubric, lambda { |global_rubric| joins(:rubric).where(doc_rubrics: { global_rubric_id: global_rubric.id }) }
  scope :mailru_widget, with_photo.approved.for_rss.order('docs.created_at DESC').limit(3)
  scope :last_week, lambda { where(docs: { created_at: (Time.now - 1.week)..(Time.now) }) }
  scope :ready_for_push_notifications_from, lambda { where("approved = ? and created_at > ?", true, 30.minutes.ago) }
  scope :without_news, lambda { joins(rubric: :global_rubric).where("doc_global_rubrics.link != ?", 'news').approved.order("created_at DESC") }
  scope :rubric_for_date, lambda {|rubric, date| global_rubric(rubric).where(created_at: date).order('docs.created_at DESC')}
  scope :for_date, lambda {|date| where(created_at: date).order('docs.created_at DESC')}

  scope :double_migrated, where('news_doc_doc_id IS NOT NULL AND news_doc_id IS NOT NULL')
  scope :migrated_once, where('news_doc_id IS NOT NULL')

  scope :popular_by_week, where("created_at > ?", 1.week.ago).reorder("page_views DESC")
  scope :popular_by_month, where("created_at > ?", 1.month.ago).reorder("page_views DESC")

  scope :by_language, lambda { where(language: I18n.locale.to_s) }

  JSON_FIELDS = [:id, :title, :created_at, :main, :page_views, :approved, :param, :updated_at]
  COMMON_FIELDS = [:title, :doc_rubric_id, :text, :annotation, :photos_attributes, :created_at, :language]
  ADMIN_FIELDS = COMMON_FIELDS | [:pictureless, :no_watermark, :approved, :approve_on, :main, :not_in_rss,
                                  :site_id, :tag_list,:important, :is_commentable, :long_image, :quote, :hero, :user_id,
                                  :top_main, :yandex_zen, :skip_sponsor_banner,
                                  {:as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  before_save :create_search
  after_save :schedule_publication, if: "approve_on.present? && approve_on > Time.zone.now"

  class << self
    def last_updated
      order('updated_at').last
    end
  end

  def as_json options = nil
    options ||= {}
    options[:only] ||= []
    options[:only] += JSON_FIELDS
    options[:include] ||= { rubric: { only: DocRubric::JSON_FIELDS } }
    super options
  end

  def controller
    self.global_rubric.link if self.global_rubric.present?
  end

  def link(path)
    "/#{path}/#{self.rubric.link}/#{self.id}-#{self.param}"
  end

  def url(options = {})
    ['', rubric.global_rubric.link, rubric.link, options[:only_id] ? self.id : to_param].join('/')
  end

  def comments_url(site = nil, domain = nil)
    host = Rails.env == 'production' ? "#{Settings['default_protocol']}://#{Settings['default_host_name']}" : ''
    [host, rubric.global_rubric.link, rubric.link, to_param, 'comments'].join('/')
  end

  private

  def create_search
    self.search = tags.map(&:name).join(', ')
  end

  def approve_on_correct
    return true if approved? || approve_on.nil?
    errors.add(:approve_on, 'Должна быть больше текущего времени.') if approve_on < Time.zone.now + 1.minutes
  end

  def schedule_publication
    Resque.enqueue_at(approve_on, DocPublicationJob, id)
  end
end
