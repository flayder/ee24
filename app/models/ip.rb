# encoding : utf-8
class Ip < ActiveRecord::Base
  belongs_to :ip_object, :polymorphic => true

  attr_accessible :ip, :ip_object_id, :ip_object_type
end
