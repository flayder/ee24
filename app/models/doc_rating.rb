# encoding : utf-8
class DocRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :ratable, :polymorphic => true

  TYPES = %w(Doc Event)

  validates_presence_of :user_id, :message => 'Голосование доступно только для зарегистрированных пользователей'
  validate :not_voted_yet

  attr_accessible :user_id, :ratable_id, :ratable_type, :value

  def not_voted_yet
    if self.ratable.voted_by?(self.user)
      errors.add(:user_id, 'вы уже голосовали')
    end
  end
end
