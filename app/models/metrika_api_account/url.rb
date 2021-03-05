class MetrikaApiAccount::Url < ActiveRecord::Base
  attr_accessible :body
  belongs_to :metrika_api_account
  has_many :search_queries, :dependent => :destroy

  validates :metrika_api_account_id, :presence => true
end