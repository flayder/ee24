namespace :users do
  task send_confirmation_reminders: :environment do
    Site.active.find_each do |site|
      notifier = UserConfirmationNotifier.new(site)
      notifier.send_reminders!
    end
  end
end
