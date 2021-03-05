# encoding : utf-8
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :vkontakte, "3134484", "M7Z6klMTNfQGs5Cb6rnq"
    provider :facebook, "1753475838295964", "8d6a8500c194fd94b098a7a74cef88a1"
    provider :google_oauth2, "175568373627-5mdv8tvm6ruoanakj7m33p2l50ea06di.apps.googleusercontent.com", "Yqv8O4FGu0m-pW8eJd7uurv3"
  else
    vkontakte_config = YAML.load(File.read(File.expand_path("#{Rails.root}/config/vkontakte.yml", __FILE__)))
    facebook_config = YAML.load(File.read(File.expand_path("#{Rails.root}/config/facebook.yml", __FILE__)))
    google_config = YAML.load(File.read(File.expand_path("#{Rails.root}/config/google.yml", __FILE__)))
    provider :vkontakte, vkontakte_config["#{Rails.env}"]["apiId"], vkontakte_config["#{Rails.env}"]["secret"]
    provider :facebook, facebook_config["#{Rails.env}"]["appKey"], facebook_config["#{Rails.env}"]["appSecret"]
    provider :google_oauth2, google_config["#{Rails.env}"]["appKey"], google_config["#{Rails.env}"]["appSecret"]
  end
end
