# encoding : utf-8
class Resume < ActiveRecord::Base
  include JobItem
  include WithUniqueText
  include WithModerationNotification
  include WithApproved
  include WithPageViews

  has_paper_trail

  COMMON_FIELDS = [:photos_attributes, :text, :money, :busy, :title, :industry_id, :contacts, :profession_ids]
  ADMIN_FIELDS = COMMON_FIELDS | [:user_id, :approved, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  def url
    (Rails.env == 'production' ? 'https://' + Settings.portal_domain : '') + '/job/resumes/' + self.id.to_s
  end
end
