# encoding : utf-8
class Admin::SiteAdminsController < Admin::BaseController
  #доступно для суперадминов и админов сайта
  #суперадмин может добавлять админов и редакторов всех сайтов
  #админ сайта может добавлять админов сайта и редакторов своего сайта

  def index
    @site_admins = SiteAdmin.includes(:user, :permissions).where(:site_id => @site.id)
  end

  def new
    @site_admin = SiteAdmin.new(:site_id => @site.id)
  end

  def create
    @site_admin = @site.site_admins.new params[:site_admin]

    if @site_admin.save
      redirect_to admin_site_admins_url, :notice => 'Доступ успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @site_admin = SiteAdmin.where(:site_id => @site.id).find(params[:id])
  end

  def update
    @site_admin = SiteAdmin.where(:site_id => @site.id).find(params[:id])
    if @site_admin.update_attributes(params[:site_admin])
      redirect_to admin_site_admins_url, :notice => 'Доступ обновлён'
    else
      render :action => :edit
    end
  end

  def destroy
    @site_admin = SiteAdmin.where(:site_id => @site.id).find(params[:id])
    @site_admin.destroy
    redirect_to admin_site_admins_url, :notice => 'Доступ удалён'
  end

  def users
    users = User.where(['email LIKE ?', "#{params[:term]}%"])
    users_json = users.map{ |u| { id: u.id, label: u.email, value: u.email } }
    render json: users_json
  end
end
