class UserCreator
  class << self
    def find_or_create_oauth(auth)
      find_for_oauth(auth)# || create_from_session(auth)
    end

    def create_from_session(auth, site = Site.find_by_domain('420on.cz'))
      data = auth['info']
      password = SecureRandom.base64(6)
      user = User.new email: data['email'], password: password, password_confirmation: password
      user["#{auth[:provider]}_uid"] = auth['uid']
      user.site = site
      user.provider = auth['provider']
      user.uid = auth['uid']
      #делаем уникальный логин
      user_login = data['nickname'].present? ?  data['nickname'] : data['name']
      user_login = 'user' if (user_login.nil? || user_login.length < 2)
      user.last_name = data['last_name']
      user.first_name = data['first_name'].present? ? data['first_name'] : data['name']
      user.unique_string(:login, user_login)
      user.confirm = true
      user.remote_avatar_url = data['image'].gsub('http://', 'https://') if data['image'].present?
      user.set_subdomain
      user.save(validate: false)
      Resque.enqueue(Mailer, 'UserMailer', :social_welcome, user.id, site.id) if user.try(:email).present?
      user
    end

    private

    def find_for_oauth(auth)
      (auth['uid'].present? ? User.send("find_by_#{auth[:provider]}_uid", auth['uid'].to_s) : nil) ||
        (auth['info']['email'].present? ? User.find_by_email(auth['info']['email']) : nil)
    end
  end
end
