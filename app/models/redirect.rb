class Redirect < ActiveRecord::Base
  include WithSite

  attr_accessible :from, :to
  validates :from, :to, presence: true
  validates :from, uniqueness: true
end
