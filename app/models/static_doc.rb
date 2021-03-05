# encoding : utf-8
class StaticDoc < ActiveRecord::Base
  include WithSite

  default_scope order('position ASC')
  scope :link, lambda { |link| where(:link => link) }
  scope :active, where(:active => true)
  scope :main, where(:main => true)

  validates_uniqueness_of :link, :scope => :site_id

  ADMIN_FIELDS = [:title, :text, :main, :link, :active, :position, :meta_title, :meta_keywords, :meta_description, { :as => :admin }]

  attr_accessible *ADMIN_FIELDS
end
