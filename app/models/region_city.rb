class RegionCity < ActiveRecord::Base
  validates :title, :region, presence: true  
  belongs_to :region
  has_many :vacancies
end
