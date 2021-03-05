class MetrikaApiAccount::SearchQuery < ActiveRecord::Base
  attr_accessible :body, :page_views, :url_id, :visits
  belongs_to :url
  validates :url_id, :presence => true
end