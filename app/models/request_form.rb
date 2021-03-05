class RequestForm < ActiveRecord::Base
  attr_accessible :full_name, :email, :phone_number, :birthday, :comment, :docable_id, :docable_type

  belongs_to :docable, polymorphic: true

  validates :full_name, :email, :birthday, :docable_id, :docable_type, presence: true

  after_create :send_notify

  private

  def send_notify
    Resque.enqueue(Mailer, 'RequestFormMailer', :request_form_notification, id)
  end
end
