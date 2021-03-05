# encoding : utf-8
class Admin::BaseController < ActionController::Base
  include Authentication
  include Authorization
  include Modules::Log

  protect_from_forgery

  layout 'admin'

  authorize_resource :prepend => true
  prepend_before_filter :find_site
  before_filter :check_admin

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "У вас нет доступа к этой странице"
  end

  private

  def check_admin
    authorize! :read, :admin_board
  end

  def find_site
    @site = SiteFinder.find_site request
    @city = @site.city
  end
end
