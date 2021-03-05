# encoding : utf-8
class SessionsController < ApplicationController
  include Modules::WithCommonLayout

  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]

  def new
    @meta_title = ["Вход / #{@site.portal_title}"]
    flash.now[:login_error] = warden.message if warden.message.present?
    session[:return_to] = params[:return_to] if params[:return_to].present?
    respond_to do |format|
      format.json { render json: {content: render_to_string(layout: false, formats: [:html])} }
      format.html { render layout: 'clean' }
    end
  end

  def create
    warden.authenticate!(:password)
    url = session[:return_to].present? ? session[:return_to] : root_url
    redirect_to url, notice: 'Добро пожаловать!'
  end

  def destroy
    url = session[:return_to].present? ? session[:return_to] : root_url
    warden.logout
    redirect_to url, notice: 'До свидания!'
  end
end