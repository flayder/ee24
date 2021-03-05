# encoding : utf-8
class DictionaryObject < ActiveRecord::Base
  include WithApproved
  include WithSite
  include Tagged
  include WithSimilarDocs

  has_paper_trail

  self.per_page = 100

  belongs_to :rubric, :class_name => 'DictionaryRubric', :foreign_key => 'rubric_id'
  belongs_to :user

  validates_presence_of :site_id, :letter, :rubric_id, :title, :text
  validates_inclusion_of :rubric_id, :in => Proc.new { |s| s.site.dictionary_rubrics.map(&:id) }, :if => :site_id?

  mount_uploader :image, PhotoUploader

  COMMON_FIELDS = [:title, :text, :letter, :type, :rubric_id, :approved, :tag_list, :image]
  #ADMIN_FIELDS = COMMON_FIELDS | [:approved, :tag_list, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  #attr_accessible *ADMIN_FIELDS

  before_validation :upcase_letter

  def url *args
    path
  end

  def path
    "/dictionaries/#{rubric.dictionary.link}/#{id}"
  end

  private
  def upcase_letter
    letter.upcase!
  end
end