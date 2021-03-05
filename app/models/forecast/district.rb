class Forecast::District < ActiveRecord::Base
  include WithSite
  attr_accessible :name, :active

  has_many :locations

  scope :active, where(active: true)

  validates :name, presence: true
end
