# encoding : utf-8
Onru::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)

  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor = Uglifier.new(compress: { unused: false }, output: { comments: :none })

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true
  config.assets.initialize_on_precompile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(ckeditor.js ckeditor/* orphus.js catalog.js catalog.css sitemap.js clean.css weather.css admin.css admin.js mobile.css mobile.js adriver.core.2.js gmaps4rails/*)

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

#  config.session_store :active_record_store, :domain => ".36on.ru"

  config.action_mailer.default_url_options = {host: '420on.cz'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
       :authentication => :plain,
       :address => "smtp.mailgun.org",
       :port => 587,
       :domain => "420on.cz",
       :user_name => "postmaster@420on.cz",
       :password => "9fot-9b7gcv2"
  }

  Rails.application.routes.default_url_options[:host] = '420on.cz'
  Rails.application.routes.default_url_options[:protocol] = 'https'
end
