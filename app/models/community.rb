class Community < ActiveRecord::Base

  attr_accessible :category_id, :description, :logo, :name, :rules, :user_id, :remote_logo_url, :open

  has_many :posts, :dependent => :destroy

  belongs_to :category
  belongs_to :user

  validates :user, presence: true

  mount_uploader :logo, CommunityLogoUploader

end
