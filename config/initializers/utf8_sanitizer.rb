# Put in /app/middleware/utf8_sanitizer.rb and add
#     config.middleware.use 'Utf8Sanitizer'
# to config/application.rb.
# See: https://gist.github.com/joost/ca4eda8f31655cf6095a
#encoding: utf-8
class Utf8Sanitizer
  SANITIZE_ENV_KEYS = %w(
    HTTP_REFERER
    PATH_INFO
    REQUEST_URI
    REQUEST_PATH
    QUERY_STRING
  )

  def initialize(app)
    @app = app
  end

  def call(env)
    SANITIZE_ENV_KEYS.each do |key|
      string = env[key].to_s
      valid = URI.decode(string).force_encoding('UTF-8').valid_encoding?
      # Don't accept requests with invalid byte sequence
      return [400, {}, ['Bad request']] unless valid
    end

    @app.call(env)
  end
end
