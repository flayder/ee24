# encoding : utf-8
module Authentication
  protected

  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def logged_in?
    current_user.present?
  end

  def login_from_cookie
    warden.authenticate(:cookie) unless logged_in?
  end

  def login_required
    logged_in? ? true : access_denied
  end

  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to login_url
      end
      accepts.xml do
        headers["Status"] = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
    end
    false
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end

=begin
    # When called with before_filter :login_from_cookie will check for an :auth_token
    # cookie and log the user back in if apropriate
    def login_from_cookie
      return unless cookies[:auth_token] && !logged_in?
      user = User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        self.current_user = user
        cookies[:auth_token] = {:domain => '.'+current_domain, :value => user.remember_token , :expires => user.remember_token_expires_at}
        #flash[:notice] = "Logged in successfully"
      end
    end
=end

  def has_access?
    logged_in? and current_user.has_access
  end

  #является админом для этого портала или общим админом
  def is_site_admin_or_editor?
    @admin_access || (logged_in? && current_user.is_editor? && current_user.has_privileges?(@site))
  end


=begin
  private
    @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
    end
=end
end
