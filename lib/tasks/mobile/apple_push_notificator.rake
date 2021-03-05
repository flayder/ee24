# encoding: utf-8
# bundle exec rake mobile:send_notifications
namespace :mobile do
  task send_notifications: :environment do
    apns = Mobile::ApplePushNotification.new
    apns.send
  end
end
