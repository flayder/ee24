# encoding : utf-8
class Street < ActiveRecord::Base
  validates :title, :city, :presence => true

  belongs_to :city

  scope :city, lambda {|field| where(:city_id => field)}
  scope :ad_agency, lambda { |id| joins(:ad_surfaces).where(ad_surfaces: { ad_agency_id: id } ) }

  has_many :ad_surfaces

  attr_accessible :title, :city_id
end
