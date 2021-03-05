# encoding : utf-8
class DocRubric < ActiveRecord::Base
  include SeoValues
  include WithAd
  include WithSite
  include WithLink

  JSON_FIELDS = [:id, :title, :english_title, :link, :position]
  ADMIN_FIELDS = [:title, :english_title, :link, :main, :global_rubric_id, :position, { :as => :admin }]
  attr_accessible *ADMIN_FIELDS

  belongs_to :global_rubric, class_name: 'DocGlobalRubric', foreign_key: 'global_rubric_id'
  has_many :docs, order: "created_at DESC", dependent: :destroy, foreign_key: :doc_rubric_id
  has_one :main_block_rubric, as: :rubric

  scope :with_docs, includes(:docs).where('docs.doc_rubric_id IS NOT NULL')

  before_create :set_position

  INTERVIEW_ID = 35
  AUTH_COLUMNS_ID = 34
  NEWS_ID = [166, 167, 168, 169, 170, 171, 172, 173]

  def as_json options = {}
    options[:only] ||= JSON_FIELDS
    super options
  end

  def title
    I18n.locale == :ru ? self.read_attribute(:title) : self.english_title
  end

  def url
    [global_rubric.link, link].join('/').prepend('/')
  end

  def position
    self[:position] || 0
  end

  def author
    "admin"
  end

  def set_position
    unless position?
      if site_id? && global_rubric_id?
        er = DocRubric.site(site_id).where(:global_rubric_id => global_rubric_id).select('max(position) as position').first
      end
      self.position = er.present? ? er.position.to_i+1 : 0
    end
  end
end
