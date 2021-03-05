# encoding : utf-8
class CommentUpdate < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  attr_accessible :user_id, :comment_id
end
