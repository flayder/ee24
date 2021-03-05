class AdAgency < ActiveRecord::Base
  has_many :ad_surfaces

  attr_accessible :title, :as => :admin
end
