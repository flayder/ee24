Bugsnag.configure do |config|
  config.api_key = "53185aee7f8817ebcad66d034a9a6317"
  config.notify_release_stages = ['production']
  config.ignore_classes << AbstractController::ActionNotFound
end
