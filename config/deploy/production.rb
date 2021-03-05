require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require "mina/hooks"
require 'mina/puma'

set :domain, '37.139.13.158'
set :rails_env, 'production'
set :branch, 'master'

set :deploy_to, '/var/www/420on'
set :repository, 'git@github.com:evrone/420on.git'
set :user, 'deploy'
set :forward_agent, true
set :rbenv_path, '/home/deploy/.rbenv/'

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

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]
  queue! %[ln -s "#{deploy_to}/shared/tmp/pids" "#{deploy_to}/shared/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]
  queue! %[ln -s "#{deploy_to}/shared/tmp/sockets" "#{deploy_to}/shared/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/sphinx"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/sphinx"]

  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config/initializers"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/backup.rb"]
  queue! %[touch "#{deploy_to}/shared/config/puma.rb"]
  queue! %[touch "#{deploy_to}/shared/config/thinking_sphinx.yml"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/secret_token.rb"]
  queue! %[echo "-----> Be sure to edit 'shared/config/database.yml, backup.rb, puma.rb, thinking_sphinx.yml, secret_token.rb'"]
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
      invoke :'puma:phased_restart'
      invoke :'ts:configure'
      invoke :'ts:restart'
      invoke :'resque:restart'
      invoke :'set_whenever'
    end
  end
end

desc "Rolls back the latest release"
task :rollback => :environment do
  queue %[echo "-----> Rolling back to previous release for instance: #{domain}"]

  # ls command below must return two rows. first of the two contains the 2nd latest version.
  queue! %[last=`ls "#{deploy_to}/releases" -Art | sort -n | tail -n 2 | sed -n '1p'`]
  queue! %[current=`ls "#{deploy_to}/releases" -Art | sort -n | tail -n 2 | sed -n '2p'`]

  # sanity check: are both versions actual numbers? is the target folder available?
  queue! %[
      if [ ! -n "$last" ] || [ ! -n "$current" ] || [ ! -d "#{deploy_to}/releases/$last" ];
      then
          echo "ERROR: No version to roll back to!";
          exit 1;
      fi
    ]

  queue %[echo "Moving from $current to $last"]

  # remove latest release folder (active release)
  queue! %[ls "#{deploy_to}/releases" -Art | sort -n | tail -n 1 | xargs -I active rm -rf "#{deploy_to}/releases/active"]

  # delete existing sym link and create a new symlink pointing to the previous release
  queue! %[rm "#{deploy_to}/current"]
  queue! %[ls -Art "#{deploy_to}/releases" | sort -n | tail -n 1 | xargs -I active ln -s "#{deploy_to}/releases/active" "#{deploy_to}/current"]
end

task :set_whenever do
  queue "echo '-----> Update cron tasks'"
  queue "cd #{deploy_to}/#{current_path} && rbenv exec bundle exec whenever -w"
end

namespace :resque do
  set :resque_pid, "#{deploy_to}/shared/pids/resque.pid"
  set :resque_sheduler_pid, "#{deploy_to}/shared/pids/resque_sheduler.pid"

  task restart: :environment do
    invoke :'resque:stop'
    invoke :'resque:start'
  end

  task start: :environment do
    queue "echo '-----> Start resque'"
    queue "cd #{deploy_to}/current && rbenv exec bundle exec resque-pool --daemon -p #{resque_pid} -E #{rails_env}"
    queue "cd #{deploy_to}/current && BACKGROUND=true PIDFILE=#{resque_sheduler_pid} RAILS_ENV=#{rails_env} rbenv exec bundle exec rake resque:scheduler"
  end

  task stop: :environment do
    queue "echo '-----> Stop resque'"
    queue "if [ -f #{resque_sheduler_pid} ] && [ -e /proc/$(cat #{resque_sheduler_pid}) ]; then kill -QUIT `cat #{resque_sheduler_pid}`; sleep 5; fi"
    queue "if [ -f #{resque_pid} ] && [ -e /proc/$(cat #{resque_pid}) ]; then kill -QUIT `cat #{resque_pid}`; sleep 5; fi"
  end
end

namespace :ts do
  desc 'Generate the Sphinx configuration file'
  task configure: :environment do
    queue "echo '-----> Generating Sphinx config'"
    queue "cd #{deploy_to}/current && RACK_ENV=#{fetch(:rails_env)} #{fetch(:bundle_bin)} exec rake ts:configure"
  end

  desc 'Restart the Sphinx daemon'
  task restart: :environment do
    queue "echo '-----> Restarting Sphinx'"
    queue "cd #{deploy_to}/current && RACK_ENV=#{fetch(:rails_env)} #{fetch(:bundle_bin)} exec rake ts:restart"
  end
end
