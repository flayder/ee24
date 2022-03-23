# encoding : utf-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'ipaddr'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

class Settings < Settingslogic
  source File.expand_path('../app.yml', __FILE__)
  namespace Rails.env

  def self.portal_email
    self[:portal_email] ||= Site.find_by_domain('420on.cz').try(:email)
  end

  def self.portal_domain
    self[:portal_domain] ||= Site.find_by_domain('420on.cz').try(:domain)
  end

  def self.portal_title
    self[:portal_title] ||= Site.find_by_domain('420on.cz').try(:portal_title)
  end

  def self.portal_map_provider
    self[:portal_map_provider] ||= Site.find_by_domain('420on.cz').try(:map_provider)
  end

  def self.watermark
    self[:portal_watermark] ||= Site.find_by_domain('420on.cz').try(:watermark)
  end
end

module Onru
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.serve_static_assets = false
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/lib/constraints"
    config.autoload_paths << "#{config.root}/lib/validators"
    config.autoload_paths << "#{config.root}/lib/liquid/filters"
    config.autoload_paths << "#{config.root}/lib/liquid/tags"
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Prague'

    config.i18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    config.i18n.available_locales = [:ru, :en]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.delivery_method = :activerecord
    config.perform_deliveries = true
    config.default_charset = "utf-8"
    config.default_content_type = "text/html"

    config.hosts = [
      IPAddr.new("0.0.0.0/0")
    ]

    config.assets.paths << Rails.root.join("app", "assets", "flash")

    config.cache_store = :redis_store, { :db => Settings.redis.db.cache, host: ENV['REDIS_HOST'] || 'localhost', port: ENV['REDIS_PORT'] || '6379' }

    # custom error handler via middleware
    # config.app_middleware.insert_after(
    #  'ActionDispatch::ShowExceptions',
    #  'CustomErrorMiddleware::RoutingError::Rack'
    # )

    config.middleware.use 'Utf8Sanitizer'
  end
end

LjConfig = YAML.load(File.read(Rails.root + 'config' + 'livejournal.yml'))

#дефолтные ключи - приложение 36on.ru
DefaultRubrics = YAML.load(File.read(Rails.root + 'config' + 'default_rubrics.yml'))
YandexDirectCodes = YAML.load(File.read(Rails.root + 'config' + 'yandex_direct.yml'))
#RamblerCodes = YAML.load_file(File.join(Rails.root, "config", "rambler_counter_codes.yml"))

require 'object'
require 'tag_extend'

PARTNER_PORTALS = %W(5.181.109.70)
