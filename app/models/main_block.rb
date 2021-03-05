#encoding: utf-8
class MainBlock < ActiveRecord::Base
  include WithSite

  DOC_TYPES = %w(Doc Event ExternalDoc)

  BLOCKS = {news: 69, events: 18, authors: 41, interview: 44}

  attr_accessible :doc_type, :position, :main_block_rubrics_attributes, :title, :path, :banner, as: :admin

  acts_as_list

  has_many :main_block_rubrics
  has_many :event_rubrics, through: :main_block_rubrics, source: :rubric, source_type: 'EventRubric'
  has_many :doc_rubrics, through: :main_block_rubrics, source: :rubric, source_type: 'DocRubric'
  has_many :external_doc_rubrics, through: :main_block_rubrics, source: :rubric, source_type: 'ExternalDocRubric'

  validates :doc_type, presence: true, inclusion: { in: DOC_TYPES }
  validates :title, :path, presence: true

  accepts_nested_attributes_for :main_block_rubrics, allow_destroy: true, reject_if: proc { |attrs| attrs[:rubric_id].blank? }

  def docs
    doc_type.constantize.site(site).approved.main.where("#{doc_type.tableize}.#{rubric_key} IN (?)", rubrics).order('created_at DESC')
  end

  def rubrics
    send rubric_name.pluralize.underscore
  end

  private
  def rubric_key
    "#{rubric_name}Id".underscore
  end

  def rubric_name
    "#{doc_type}Rubric"
  end
end
