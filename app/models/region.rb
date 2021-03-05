class Region < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true

  has_many :cities, class_name: 'RegionCity'
end
