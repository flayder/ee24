# encoding : utf-8
class OmniauthSessionsController < ApplicationController
  layout "clean"

  before_filter :not_logged_in_required

  def setup
    render :text => "Setup complete.", :status => 404
  end

  def create
    auth = request.env["omniauth.auth"]
    @user = UserCreator.find_or_create_oauth(auth)
    #залогиним пользователя
    if @user
      warden.set_user @user
      url = session[:return_to].present? ? session[:return_to] : root_url
      redirect_to url, :notice => "Добро пожаловать!"
    else
      redirect_to root_url, :notice => "Регистрация временно отключена"
    end
  end
end
