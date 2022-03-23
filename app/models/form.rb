class Form < ActiveRecord::Base
  attr_accessible :title, :data

  #belongs_to :docable, polymorphic: true

  validates :title, :data, presence: true

  #after_create :send_notify

  #private

  #def send_notify
  #  Resque.enqueue(Mailer, 'RequestFormMailer', :request_form_notification, id)
  #end
end
