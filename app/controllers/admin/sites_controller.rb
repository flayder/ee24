# encoding : utf-8
class Admin::SitesController < Admin::BaseController
  authorize_resource :site

  def index
    @sites = Site.partner
  end

  def new
    @site_ = Site.new
  end

  def create
    @site_ = Site.new params[:site]
    @site_.is_partner = true

    if @site_.save
      redirect_to admin_site_path(@site_), :notice => 'Портал создан.'
    else
      render :action => :edit
    end
  end

  def show
  end

  def edit
    @site_ = Site.find params[:id]
  end

  def update
    @site_ = Site.find params[:id]

    if @site_.update_attributes(params[:site])
      Settings.reload!
      redirect_to admin_site_path(@site_), :notice => 'Информация о портале успешно обновлена'
    else
      render :action => :edit
    end
  end

  def destroy
    @site_ = Site.find params[:id]
    @site_.destroy
    redirect_to :back
  end

  def change_default_site
    raise ActionController::UnknownAction if Rails.env.production?
    Settings['default_host_name'] = params[:default_host_name]
    redirect_to root_path
  end
end
