# encoding : utf-8
class PhotoRubric < ActiveRecord::Base
  include WithAd
  include WithLink
  include WithSite

  ADMIN_FIELDS = [:title, :link, :main, { :as => :admin }]
  attr_accessible *ADMIN_FIELDS

  has_many :seos, as: :seo

  has_many :galleries

  scope :approved, where(:approved => true)
  scope :ordered, order('position')

  validates :title, :link, :presence => true

  def block_galleries
    self.galleries.approved.order('created_at desc').limit(6)
  end

  def url
    URI.escape("/photo/#{link}")
  end
end
