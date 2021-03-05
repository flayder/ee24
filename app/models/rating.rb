class Rating < ActiveRecord::Base
  attr_accessible :positive, :rateable_id, :rateable_type

  belongs_to :rateable, polymorphic: true
  belongs_to :user

  scope :positive, where(positive: true)
  scope :negative, where(positive: false)

  validates :user_id, uniqueness: {scope: [:rateable_type, :rateable_id]}

end
