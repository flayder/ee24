# encoding : utf-8
class DictionaryRubric < ActiveRecord::Base
  include SeoValues
  include WithAd
  include WithSite

  belongs_to :dictionary
  has_many :dictionary_objects, :class_name => 'DictionaryObject', :foreign_key => 'rubric_id', :dependent => :destroy
  has_many :objects, :class_name => 'DictionaryObject', :foreign_key => 'rubric_id', :dependent => :destroy
  
  validates_presence_of :title
  attr_accessible :title, :dictionary_id, :image

  mount_uploader :image, PhotoUploader

  def path
    "/dictionaries/#{dictionary.link}/rubric/#{id}"
  end

  def url
    path
  end
end
