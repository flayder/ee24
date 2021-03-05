require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain, '188.166.18.99'
set :rails_env, 'production'
set :branch, 'mobile-layout'

set :deploy_to, '/srv/420on'
set :repository, 'git@github.com:evrone/420on.git'
set :user, 'deploy'
set :forward_agent, true
set :rbenv_path, "/usr/local/rbenv"

set :shared_paths, [
  'config/database.yml',
  'config/puma.rb',
  'config/initializers/secret_token.rb',
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

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
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
      queue "sv -v restart /srv/420on/service/puma"
      # queue "sv -v restart /srv/420on/service/resque"
    end
  end
end

namespace :copy_assets do
  task :ckeditor do
    queue "echo '-----> Copy ckeditor assets'"
    queue "cp -r #{deploy_to}/#{current_path}/vendor/gems/ckeditor-3.7.0.rc2/vendor/assets/javascripts/ckeditor #{deploy_to}/#{current_path}/public/assets"
  end

  task :gmaps4rails do
    queue "echo '-----> Copy gmaps4rails assets'"
    queue "cp -r #{deploy_to}/#{current_path}/vendor/assets/gmaps4rails-1.5.2 #{deploy_to}/#{current_path}/public/assets/gmaps4rails"
  end
end
