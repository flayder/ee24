# encoding : utf-8
class SocialWidgetCode < ActiveRecord::Base
  include WithSite

  validates :widget_type, :site_id, presence: true

  attr_accessible :code, :widget_type
    

  
end
