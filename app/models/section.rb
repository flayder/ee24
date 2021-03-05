# encoding : utf-8
class Section < ActiveRecord::Base
  validates :title, :controller, :presence => true
  has_many :site_sections, :dependent => :destroy
  has_many :sites, :through => :site_sections

  scope :with_city, where(:with_city => true)
  scope :without_city, where(:with_city => false)
  scope :dictionaries, where("controller LIKE 'dictionary/%'")
  scope :in_sitemap, where(in_sitemap: true)

  attr_accessible :title, :controller, :position, :with_rubrics, :with_city, :in_sitemap
end
