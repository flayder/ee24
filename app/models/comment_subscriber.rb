class CommentSubscriber < ActiveRecord::Base

  belongs_to :subscriberable, polymorphic: true
  belongs_to :user

end
