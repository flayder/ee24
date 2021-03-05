# encoding : utf-8

class BrokerHelpMailer < ActionMailer::Base
  default_url_options[:host] = "420on.cz"
  DEFAULT_EMAIL_TO = 'info@420on.cz'
  DEFAULT_EMAIL_FROM = "info@420on.cz"

  def broker_help_notification(options)
    @user_info = options
    mail(
      subject: "Запрос помощи брокера по недвижимости на сайте #{default_url_options[:host]}",
      to: [DEFAULT_EMAIL_TO].delete_if(&:blank?),
      from: DEFAULT_EMAIL_FROM
    )
  end
end
