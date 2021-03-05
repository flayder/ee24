# encoding : utf-8
class UserVisit < ActiveRecord::Base
  belongs_to :user

  attr_accessible
end
