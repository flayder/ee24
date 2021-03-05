class Post < ActiveRecord::Base

  acts_as_paranoid

  attr_accessible :community_id, :content, :title, :user_id

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  belongs_to :community
  belongs_to :user

  validates :community_id, :title, :content, presence: true

  def url
    ['', 'categories', community.category.id, 'communities', community.id, 'posts', self.id].join('/')
  end

end
