# encoding: utf-8
require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'
require 'pry'
require 'omniauth'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start

  if ENV['RCOV']
    require 'simplecov'
    require 'simplecov-rcov'
    SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
    SimpleCov.start
  end

  ENV["RAILS_ENV"] ||= 'test'
  OmniAuth.config.test_mode = true

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'capybara/rails'

  require File.dirname(__FILE__) + "/macros/controller_macros"
  Dir[Rails.root.join("spec/shared examples/**/*.rb")].each { |f| require f }
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  Capybara.default_wait_time = 20
  Capybara.javascript_driver = :webkit
  Capybara::Webkit.configure do |config|
    config.allow_url("www.google.com")
    config.allow_url("ajax.googleapis.com")
  end

  class RSpec::Core::Example
    def passed?
      @exception.nil?
    end

    def failed?
      !passed?
    end
  end

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include(ControllerMacros, :type => :controller)
    config.include(Capybara::DSL, :type => :request)

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_fixtures = true

    config.render_views = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
    config.infer_spec_type_from_file_location!

    # config.around(:each, type: :request) do |example|
    #   retry_on_timeout do
    #     example.run
    #   end
    # end

    config.include OutOfTransactions, trunc: true
    config.include OutOfTransactions, type: :request
  end
end

Spork.each_run do
  RSpec.configure do |config|
    # This code will be run each time you run your specs.
    config.before(:each, type: :request) do |example|
      skip '***** ALL REQUEST TESTS NEED REWRITE ******'
      location = "#{example.metadata[:file_path]}:#{example.metadata[:line_number]}"
      Rails.logger.info ">>>#{location}<<<"
    end

    config.after(:each, type: :request) do |example|
      browser = Capybara.current_session.driver.browser
      if browser.respond_to?(:clear_cookies)
        # Rack::MockSession
        browser.clear_cookies
      elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
        # Selenium::WebDriver
        browser.manage.delete_all_cookies
      else
        raise "Don't know how to clear cookies. Weird driver?"
      end
    end

    config.after(:each, type: :request) do |example|
      # formatter = RSpec::Core::Formatters::BaseTextFormatter.new(nil)
      # location = "#{example.metadata[:file_path]}:#{example.metadata[:line_number]}"
      #
      # if example.failed?
      #   log = [
      #       location,
      #       example.exception.message,
      #       example.exception.backtrace.join("\n")
      #   ].join("\n")
      #   puts formatter.colorize(log, :red)
      # elsif example.passed?
      #   puts formatter.colorize(location, :green)
      # end
    end

    config.after(:each, type: :request) do |example|
      if example.failed?
        Rails.logger.info "&&&&>ERROR WHILE SPEC '#{example.metadata[:full_description]}'<&&&&"
        Rails.logger.info "DOM"
        # Rails.logger.info example.body
        Rails.logger.info "end DOM"
      end
    end

    config.before(:all) do
      DatabaseCleaner.clean
      Site.create(id: 93,
                  portal_title: 'Пражский городской портал',
                  domain: '420on.cz',
                  email: 'info@420on.cz') unless Site.exists?(id: 93)
    end

    config.after(:each, type: :request) do
      DatabaseCleaner.clean
    end
  end
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
