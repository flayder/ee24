# encoding : utf-8
class WebAnalyticsBlock < ActiveRecord::Base
  include WithSite

  CODE_TYPES = ['google_analytics', 'yandex_metrika']
  #validates_uniqueness_of :site_id

  attr_accessible :body, :code_type

  scope :invisible, where('code_type not like "%_visible"')

end
