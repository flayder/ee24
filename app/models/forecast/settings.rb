class Forecast::Settings < ActiveRecord::Base
  include WithSite
  attr_accessible :login, :password, :background_cache, :background, :remove_background, :subdomain, :default_location_id

  validates :site_id, uniqueness: true, :if => :site_id?
  belongs_to :default_location, class_name: 'Forecast::Location', foreign_key: :default_location_id

  mount_uploader :background, BackgroundUploader
end
