class Forecast::Icon < ActiveRecord::Base
  include WithSite

  attr_accessible :background_cache, :background, :remove_background, as: :admin

  mount_uploader :background, BackgroundUploader

  scope :with_background, where("background <> ''")
end
