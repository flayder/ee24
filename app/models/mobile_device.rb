class MobileDevice < ActiveRecord::Base
  include WithSite

  attr_accessible :token

  validates :token, presence: true, uniqueness: { scope: :site_id }
end
