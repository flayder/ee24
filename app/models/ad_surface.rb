# encoding : utf-8
class AdSurface < ActiveRecord::Base
  include WithCity
  include WithStreet
  #только в Воронеже - чтобы не указывать лишний раз
  before_validation :set_city

  belongs_to :ad_agency
  belongs_to :ad_format

  validates :title, :ad_agency_id, :ad_format_id, :address, :presence => true

  mount_uploader :photo, AdSurfacePhotoUploader
  mount_uploader :second_photo, AdSurfacePhotoUploader

  geocoded_by :gmaps4rails_address, :latitude => :lat, :longitude => :lng
  after_validation :geocode

  COMMON_FIELDS = []
  ADMIN_FIELDS = COMMON_FIELDS | [:title, :address, :ad_agency_id, :ad_format_id, :street_id, :description, :photo, :photo_cache, :second_photo, :second_photo_cache, :remove_photo, :remove_second_photo, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  scope :map_surfaces, where('lat IS NOT NULL AND lng IS NOT NULL')
  
  def set_city
    self.city = City.voronezh
  end

  def images_changed?
    self.photo_changed? || self.second_photo_changed?
  end
end
