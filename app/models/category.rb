class Category < ActiveRecord::Base
  attr_accessible :description, :logo, :name, :english_name, :remote_logo_url

  mount_uploader :logo, BankLogoUploader

  has_many :communities
  has_many :questions, order: 'created_at DESC', dependent: :restrict
  has_many :posts, through: :communities

  def filter_communities(user)
    communities.where("open = true OR user_id=#{user.id}")
  end

  def name
    I18n.locale == :ru ? self.read_attribute(:name) : self.english_name
  end
end
