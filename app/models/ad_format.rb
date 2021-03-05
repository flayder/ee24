# encoding : utf-8
class AdFormat < ActiveRecord::Base
  has_many :ad_surfaces

  attr_accessible :title, :as => :admin
  validates :title, :presence => true

  COMMON_FIELDS = []
  ADMIN_FIELDS = COMMON_FIELDS | [:title, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS
end
