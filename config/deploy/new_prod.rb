require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require "mina/hooks"

set :domain, '212.83.179.178'
set :rails_env, 'production'
set :branch, 'master'

set :deploy_to, '/var/www/420on'
set :repository, 'git@github.com:finist/420on.git'
set :user, 'u420on'
set :rbenv_path, '/home/u420on/.rbenv/'

set :shared_paths, [
  'config/database.yml',
  'config/puma.rb',
  'config/initializers/secret_token.rb',
  'config/thinking_sphinx.yml',
  'config/production.sphinx.conf',
  'config/backup.rb',
  'public/uploads',
  'public/system',
  'public/sitemap.xml.gz',
  'public/sitemap_google_news.xml.gz',
  'log',
  'tmp'
]

task :environment do
  queue %{export RBENV_ROOT=#{rbenv_path}}
  invoke :'rbenv:load'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'puma:restart'
      invoke :'resque:restart'
      invoke :'ts:restart'
      invoke :'set_whenever'
    end
  end
end

namespace :puma do
  task restart: :environment do
    queue "echo '-----> Restart Puma'"
    queue "sudo systemctl restart puma.service"
  end
end

namespace :resque do
  task restart: :environment do
    queue "echo '-----> Restart Resque'"
    queue "sudo systemctl restart resque.service"
  end
end

namespace :ts do
  task restart: :environment do
    queue "echo '-----> Restart Thinking Sphinx'"
    queue "sudo systemctl restart ts.service"
  end
end

task :set_whenever do
  queue "echo '-----> Update cron tasks'"
  queue "cd #{deploy_to}/#{current_path} && rbenv exec bundle exec whenever -w"
end
