source 'http://rubygems.org'

gem 'rails', '3.2.17'

gem 'morpher_inflect'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass', '3.3.7'
gem 'sass-rails',   '~> 3.2.6'

group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

# if RUBY_VERSION =~ /1.9/
#   Encoding.default_external = Encoding::UTF_8
#   Encoding.default_internal = Encoding::UTF_8
# end

gem 'ultimate-flash', '~> 0.8.0'
gem 'ultimate-base', '~> 0.4.0.1'
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails'
gem 'fotoramajs'
gem 'jquery-slick-rails'
gem 'font-awesome-rails'
gem 'therubyracer'
gem 'less-rails'
gem 'bourbon'
gem 'bootstrap-sass', '3.1.1'
gem 'haml'
gem 'liquid'
gem 'faker' # для показа вёрстки категорий, сообществ, вопросов, постов, тегов
gem "jstree-rails-4"

gem 'aws-s3'
gem 'bitly'
gem 'orm_adapter'
gem 'acts-as-taggable-on', '3.0.1'
gem 'acts_as_tree'
gem 'acts_as_list'
gem 'mechanize'
gem 'mysql2'
gem 'rmagick'
gem 'thinking-sphinx' #, '3.1.4'
gem 'whenever', require: false
gem 'oauth'
gem 'omniauth'
# Локальный гем вконтакта нужен только для того, чтобы в нем прописать 'omniauth-oauth2' версии ~> 1.2,
# которая нужна для совместимости с обновленным гемом 'omniauth-facebook'
# Как только выдйдет (если выйдет) официальный гем с этой версией omniauth-oauth2, то можно переключаться на гитхаб
gem 'omniauth-vkontakte', path: "./vendor/omniauth-vkontakte"
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'will_paginate', '~> 3.1.0'
gem 'russian'
gem 'awesome_nested_set'
gem 'ancestry'
gem 'carrierwave', '0.8.0'
gem 'carrierwave_backgrounder'
gem 'carrierwave-imageoptimizer'
gem 'warden'
gem 'polymorphic_render'

gem 'nokogiri', require: false
gem 'fb_graph', require: false
gem 'grocer', require: false

gem 'ckeditor', '4.1.2'
gem 'mini_magick'

gem 'gmaps-autocomplete-rails'
gem 'sitemap_generator'#, require: false

gem 'htmlentities'
gem 'gmaps4rails', '1.5.2'
gem 'geocoder'
gem 'settingslogic'
gem 'paper_trail', '2.7.1'
gem 'differ', require: false
gem 'resque'
gem 'resque-pool', '~> 0.6'
gem 'resque-scheduler'
gem 'redis-rails'
gem 'money-rails'
gem 'aasm'
gem 'cocoon'
gem 'geo_position'
gem 'validates'

gem 'meta_search'
gem 'simple_form'

gem 'cancan'

gem 'livejournal', require: false

gem 'ruby-stemmer', '>=0.8.3', require: false

# for fetching yandex metrika api
gem 'em-synchrony', require: false
gem 'em-http-request', require: false

gem 'bugsnag'

gem 'paranoia', "~> 1.0"

gem 'puma'
gem 'progress_bar'

gem "mobile_view", "~> 0.3.0"

gem "recaptcha", '0.4.0', require: "recaptcha/rails" # old version, but last version that supports ruby 1.9

gem 'cookies_eu'

group :test, :development do
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-its'
  gem 'factory_girl_rails'
  # gem 'listen'
  gem 'rb-fsevent', require: false
  gem 'letter_opener', '~> 1.1.1'
  gem 'pry'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'ci_reporter'
  gem 'shoulda'
  gem 'capybara', '2.4.4'
  gem 'selenium-webdriver', '2.45.0'
  # gem 'capybara-webkit'
  gem 'rubyzip', '>= 1.0.0' # will load new rubyzip version
  gem 'zip-zip' # will load compatibility for old rubyzip API.
  gem 'launchy'
  #gem 'guard-rspec'
  gem 'rb-readline'
  gem 'resque_spec', '~> 0.16'
  gem 'timecop'
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'spork', '~> 1.0rc'
end

group :development do
  gem 'lol_dba'
  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'rvm-capistrano',  require: false

  gem 'quiet_assets'
  gem 'mina', '0.3.8'
  gem 'mina-hooks'
  gem 'mina-multistage', require: false
  gem 'mina-puma', require: false
  #gem 'guard-livereload'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
end
