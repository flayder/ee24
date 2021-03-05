# encoding : utf-8
module ControllerMacros
  def self.included(base)
    base.before(:each) do
      set_default_site
    end
  end

  def set_default_site
    @site = Site.find_by_domain('420on.cz') || create(:site, domain: '420on.cz')
    @city = @site.city

    allow(controller).to receive(:login_from_cookie).and_return(true)

    manager = Warden::Manager.new(
      nil,
      &Rails.application.config.middleware.detect do
        |m| m.name == 'Warden::Manager'
      end.block
    )
    @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
  end

  def login user
    allow(controller).to receive(:current_user).and_return(user)
  end

  def logout
    allow(controller).to receive(:current_user).and_return(nil)
  end

  def user_login user = nil
    user = create(:user) unless user
    login user
  end

  def admin_login user = nil
    user = create(:admin) unless user
    login user
  end
end
