# encoding : utf-8
application = "420on"
rails_env = "production"
ruby = "ruby-1.9.3-p448"
deploy_to = "/var/www/#{application}"
current = "#{deploy_to}/current"

job_type :rake, "cd :path && RAILS_ENV=:environment rbenv exec bundle exec rake :task :output"

if environment == 'production'

  every 3.hours do
    command "cd #{current} && rbenv exec bundle exec rails runner -e production 'ExchangeRate.load_current_exchange_rates'"
  end

  every 1.day do
    rake 'stat_counters:generate_todays'
  end

  every 2.hours do
    rake "ts:index"
  end

  every 30.minutes do
    rake "page_views:update"
  end

  every :day, :at => '2:30am' do
    rake "sitemap:refresh CONFIG_FILE='config/sitemap.rb'"
  end

  every :day, :at => '2:00am' do
    rake "sitemap:refresh CONFIG_FILE='config/google_news_sitemap.rb'"
  end

  every :day, :at => '3am' do
    command "cd #{current} && rbenv exec backup perform --trigger #{application} --config-file #{current}/config/backup.rb"
  end

  every :day, at: '2:30am' do
    rake 'users:send_confirmation_reminders'
  end

  every :day, at: '3:30am' do
    rake 'sessions:cleanup'
  end

end
