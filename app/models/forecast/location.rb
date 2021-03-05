class Forecast::Location < ActiveRecord::Base
  attr_accessible :district_id, :lat, :lng, :name, :foreca_id

  belongs_to :district
  has_many :datas

  validates :district_id, :lat, :lng, :name, :foreca_id, :param, presence: true

  before_validation :assign_param

  scope :for_menu, lambda { |site| joins(:district).where(forecast_districts: { site_id: site.id, active: true }).order('forecast_locations.name') }

  def to_param
    param
  end

  def self.site_location(site, location_id)
    joins(:district).where(forecast_districts: { site_id: site.id, active: true }).where('forecast_locations.param = ?', location_id).first!
  end

  private
  def assign_param
    self.param = Russian.translit(name).split.join('-').downcase
    true
  end
end
