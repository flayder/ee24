namespace :sessions do
  desc "Clear expired sessions (more than 1 week old)"
  task :cleanup => :environment do
    ActiveRecord::SessionStore::Session.where("updated_at < ?", 1.weeks.ago).delete_all
  end
end
