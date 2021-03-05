# encoding : utf-8
class Dictionary < ActiveRecord::Base
  include WithAd
  include WithSite

  attr_accessible :description, :link, :title

  has_many :rubrics, class_name: 'DictionaryRubric'

  validates_presence_of :link, :title, :site_id

  def dictionary_objects
    DictionaryObject.where(rubric_id: rubrics)
  end

  def path
    url
  end

  def url
    "/dictionaries/#{link}"
  end
end
