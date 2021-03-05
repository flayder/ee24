# encoding : utf-8

class RequestFormMailer < ActionMailer::Base
  default_url_options[:host] = "420on.cz"
  DEFAULT_EMAIL_TO = 'info@420on.cz'
  DEFAULT_EMAIL_FROM = "info@420on.cz"

  def request_form_notification(request_form_id)
    @site = Site.find(93)
    @request_form = RequestForm.find(request_form_id)
    mail(
      subject: "Получена новая заявка на сайте #{default_url_options[:host]}",
      to: [DEFAULT_EMAIL_TO].delete_if(&:blank?),
      from: DEFAULT_EMAIL_FROM
    )
  end
end
