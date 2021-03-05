# encoding : utf-8
module WithModerationNotification
  def self.included(base)
    base.class_eval do
      after_commit :notify_user_about_moderation, on: :create, unless: :approved?
    end
  end

  def notify_user_about_moderation
    if self.user && self.user.email_notification?
      Resque.enqueue Mailer, 'UserMailer', :moderation_notification, self.class.name, self.id
    end
  end
end
