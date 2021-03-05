# encoding : utf-8
Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda { |env| SessionsController.action(:new).call(env) }
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Manager.on_request do |proxy|
  proxy.logout(:default) if proxy.user && proxy.user.ban?
end

Warden::Strategies.add(:password) do
  def valid?
    params['email'] && params['password']
  end

  def authenticate!
    user = User.find_by_email(params['email'])

    if user && user.ban?
      fail "Ваш профиль заблокирован."
    elsif user && user.authenticate(params['password'])
      success! user
    else
      fail "Неправильный логин или пароль"
    end
  end
end

Warden::Strategies.add(:cookie) do
  def valid?
    req = ActionDispatch::Request.new(env)
    req.cookie_jar.signed['user.remember.token']
  end

  def authenticate!
    req = ActionDispatch::Request.new(env)
    remember_cookie = req.cookie_jar.signed['user.remember.token']
    if user = User.find_by_remember_token(remember_cookie)
      success! user
    end
  end
end

Warden::Manager.after_authentication do |user, auth, opts|
  user.remember_me
  if auth.request.params['remember_me'] == 'on'
    request = ActionDispatch::Request.new(auth.env)
    request.cookie_jar.signed['user.remember.token'] = {
      :value => user.remember_token,
      :expires => 2.weeks.from_now
    }
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  user.update_attribute :remember_token, nil
  request = ActionDispatch::Request.new(auth.env)
  request.cookie_jar.delete 'user.remember.token'
end
