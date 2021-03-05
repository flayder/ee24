# encoding : utf-8
class DocGlobalRubric < ActiveRecord::Base
  include SeoValues
  include WithAd
  include WithLink
  include WithSite

  has_many :doc_rubrics, dependent: :destroy, order: '(position is null), position', foreign_key: 'global_rubric_id'
  scope :user_added, :conditions => {:user_added => 1, :doc_rubrics => {:user_added => 1}}, :include => :doc_rubrics

  attr_accessible :title, :english_title, :link, :position, as: :admin

  def title
    I18n.locale == :ru ? self.read_attribute(:title) : self.english_title
  end

  def as_json options = {}
    options[:only] ||= [:id, :title, :link]
    super(options).merge(
      'doc_rubrics' => doc_rubrics.with_docs.as_json
    )
  end

  def position
    self[:position] || 0
  end

  def docs site
    Doc.site(site).where(doc_rubric_id: doc_rubrics)
  end

  def url
    link
  end

  # hack for showing banners
  def children
    doc_rubrics
  end
end
