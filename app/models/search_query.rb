class SearchQuery < ActiveRecord::Base
  attr_accessible :query
  include WithSite
  
  validates :query, :site, :presence => true
end