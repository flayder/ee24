class MetrikaApiAccount < ActiveRecord::Base
  attr_accessible :app_id, :app_password, :counter_id, :token

  belongs_to :site
  has_many :urls, :dependent => :destroy

  validates :site_id, :presence => true

  def authorized?
    token? && app_id? && app_password?
  end
end