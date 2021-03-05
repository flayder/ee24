class Permission < ActiveRecord::Base
  belongs_to :site_admin
  belongs_to :section

  attr_accessible :section_id

  delegate :user, :to => :site_admin
  delegate :controller, :to => :section

  validates :site_admin_id, :uniqueness => { :scope => :section_id }

  delegate :user, :to => :site_admin
  delegate :user_id, :to => :site_admin
  delegate :site_id, :to => :site_admin
end