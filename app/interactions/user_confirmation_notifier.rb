class UserConfirmationNotifier < Struct.new(:site)
  def send_reminders!
    site.users.not_confirmed.last_day.find_each do |user|
      send_confirmation(user)
    end
  end

  def send_confirmation(user)
    user.update_confirmation_token
    Resque.enqueue(Mailer, 'UserMailer', :confirm, user.id, site.id)
  end
end
