# encoding : utf-8
class ApplicationController < ActionController::Base
  require 'will_paginate/array'

  include Authentication
  include Authorization

  include Modules::Log
  include Modules::Blocks
  include Modules::Rss
  include Modules::WithRedirect

  protect_from_forgery

  before_filter :escape_emoji

  before_filter :mobile_switching
  has_mobile_view

  prepend_before_filter :set_site_and_city
  before_filter :set_locale
  before_filter :check_redirect
  before_filter :check_if_subdomain
  before_filter :set_page_generation_start_time
  before_filter :login_from_cookie
  before_filter :configure_charsets
  #before_filter :admin_access
  before_filter :visit_session_set
  before_filter :chop_url, :get_seo, :get_banners
  before_filter :manage_params_page
  before_filter :set_search_action
  before_filter :block_linker
  before_filter :user_confirmed, only: [:new, :edit, :create, :update, :delete]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "У вас нет доступа к этой странице"
  end

  rescue_from ActionView::MissingTemplate do |exception|
    render_error(404)
  end

  before_filter do |controller|
    if controller.request.format.present? && controller.request.format.html? && !%w(sessions omniauth_sessions).include?(params[:controller]) && request.path != '/account/signup' && controller.request.get?
      controller.send(:set_return_to)
    end
  end

  after_filter :user_log

  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  # prepend_around_filter :render_500

  def manage_params_page
    if params[:page]
      #некорректное значение
      params[:page] = params[:page].respond_to?(:to_i) ? params[:page].to_i : 1
      if params[:page] < 1
        render_404
        return false
      end
      if params[:page] == 1
        params.delete(:page)
        redirect_to request.path, params: params, status: :moved_permanently
        return false
      end
    end
    if request.subdomain.present? && !I18n.available_locales.map(&:to_s).include?(request.subdomain)
      redirect_to(request.protocol + request.domain + (request.port.nil? ? '' : ":#{request.port}") + request.path)
      return
    end
  end

  def info_for_paper_trail
    { :site_id => @site.id }
  end

  def set_search_action

    @search_action = case params[:controller]
                     when 'main' then 'docs'
                     when 'news' then 'docs'
                     when 'afisha' then 'events'
                     when 'catalog' then 'companies'
                     when 'job' then 'vacancies'
                     when 'magazine' then 'docs'
                     when 'photo' then 'photos'
                     else 'docs'
    end
  end

  def set_page_generation_start_time
    @page_generation_start_time = Time.now
  end

  def robots
    headers["Content-Type"] = "text/plain; charset=utf-8"
    render text: @site.robots
  end

  def configure_charsets
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute "set names 'utf8'"
    end
  end

  def admin_access
    @admin_access = logged_in? && current_user.user_type == 'admin'
  end

  def admin_required
    unless @admin_access
      render_404
      return false
    end
  end

  def login_required
    unless logged_in?
      redirect_to '/account/login'
    end
  end

  def not_logged_in_required
    redirect_to '/' if logged_in?
  end

  def render_404
    render_error(404)
  end

  def render_403
    render_error(403)
  end

  def render_500
    @broads = ['Ошибка 500']

    if Onru::Application.config.consider_all_requests_local
      yield
      return
    end

    begin
      yield
    rescue Exception => e
      if [
        "LocalJumpError",
        "ActionController::UnknownAction",
        "ActiveRecord::RecordNotFound",
        "AbstractController::ActionNotFound",
        "ActionController::RoutingError",
        "CanCan::AccessDenied"
      ].include?(e.class.to_s) || ["invalid date"].include?(e.message.to_s)
        render_error(404)
      else
        # notify_airbrake(e)
        render_error(500)
      end
      return
    end
  end

  # TODO Убрать эту функцию из аппликейшн.рб
  # Функция-фильтр пробелов.
  # Удаляет повторяющиеся пробелы и убирает пробелы в начале и в конце.
  def filter_space(str)
    return str.gsub!(/ +/,' ').strip
  end

  def chop_url
    if request.path =~ /^.*\/$/ and request.path != '/'
      redirect_to request.url.chop
      return false
    end
  end

  def get_seo
    #seo для конкретной страницы
    if @seo = Seo.site(@site.id).where(path: request.path).by_language.where('seo_type IS NULL OR seo_type = ""').first
      @seo_about = @seo.about
      @seo_sub_text = @seo.sub_text
      #@seo_text = @seo.text

      @meta_title ||= @seo.title
      @meta_description ||= @seo.description
      @meta_keywords ||= @seo.keywords
    end
  end

  def get_banners
    # REFACTOR
    # with inject
    # cover with specs
    banners = AdCode.site(@site.id).where(:url => request.path)
    @ad_codes = {}
    banners.each do |banner|
      @ad_codes[banner.banner_type] = banner.code
    end
  end

  private

  def privileged_access?
    logged_in? && current_user.has_privileges?(@site)
  end

  def set_return_to
    session[:return_to] = request.url unless request.url =~ /\/not_allowed\z/
  end

  def render_error(code)
    render template: 'application/error_pages', layout: false, status: code, formats: [:html]
  end

  def go_back
    redirect_to :back

    #Catch exception and redirect to root
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end

  def check_if_subdomain
    return true if request.subdomain == "www" && Rails.env.test?
    return true if request.subdomain == "divmaxx"

    # permit subdomain for Foreca weather
    if !@site.forecast_settings.subdomain.blank? &&
      request.subdomain == @site.forecast_settings.subdomain

      if params[:controller] == 'forecast/locations'
        return true
      else
        redirect_to(forecast_location_forecast_path(
            subdomain: @site.forecast_settings.subdomain,
            location_id: @site.forecast_settings.default_location,
            days_number: Forecast::Data::AVAILABLE_DAYS.first
          )
        ) and return
      end
    end
  end

  def set_site_and_city
    @img_domain = "https://420on.cz"
    @site = Site.find_by_domain('420on.cz')
    render_404 and return unless @site
    @city = @site.city
  end

  def user_confirmed
    if current_user.present? && !current_user.confirm?
      redirect_to user_not_confirm_path(current_user.subdomain), notice: 'Пожалуйста подтвердите ваш аккаунт.' and return
    end
  end

  def mobile_switching
    # if params[:_mobile_view] == 'no'
    #   force_non_mobile!
    # elsif params[:_mobile_view] == 'yes' || cookies[:mobile] == '1'
    #   force_mobile!
    # end
    force_non_mobile!
  end

  def escape_hash_params(hash)
    escape_attributes = ['title', 'subject', 'description', 'content', 'annotation', 'text', 'about', 'additional_info']
    hash.each{ |k, v|
      hash[k] = v.kind_of?(Hash) ? escape_hash_params(v) :
                                   escape_attributes.include?(k) ? ActiveSupport::JSON.decode(v.to_json.unpack('U*').reject{ |e| e.between?(0x1F300, 0x1F943) }.pack('U*')) : v
    }
  end

  def escape_emoji
    escape_hash_params(params)
  end
end
