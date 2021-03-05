class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  has_many :ratings, as: :rateable

  MAX_LEVEL = 3

  attr_accessible :commentable_id, :commentable_type, :text, :user_id, :parent_id

  acts_as_nested_set

  def published_at
    updated? ? updated_at : created_at
  end

  def updated?
    created_at != updated_at
  end

  def rating
    ratings.positive.count - ratings.negative.count
  end

  def has_rating_from(user)
    ratings.where(user_id: user.id).present?
  end

end
