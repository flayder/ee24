# encoding : utf-8
class City < ActiveRecord::Base
  has_one :site
  has_many :streets

  attr_accessible

  geocoded_by :title, :latitude => :lat, :longitude => :lng
  after_validation :geocode, :if => :title_changed?

  scope :abc_order, order('title ASC')
  
  def voronezh?
    (self.title == 'Воронеж')
  end

  def self.voronezh
    City.first(:conditions => {:title => 'Воронеж'})
  end

  def self.voronezh_id
    1
  end

  def seo_title
    "г #{title}"
  end
end