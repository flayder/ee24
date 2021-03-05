# encoding : utf-8
class Admin::UsersController < Admin::BaseController
  authorize_resource :user

  def index
    sites = @site.is_partner? ? @site : Site.not_partner.pluck(:id)
    @search = User.where(site_id: sites).metasearch(params[:search])
    @users = @search.page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        @users = User.where(site_id: sites)
        send_data @users.to_csv, filename: "users-#{Date.today}.csv"
      end
    end
  end

  def toggle_ban
    user = User.find params[:id]

    if user.toggle(:ban).save
      redirect_to :back, :notice => user.ban? ? 'Юзер забанен.' : 'Юзер отбанен.'
    else
      redirect_to :back, :error => 'Что-то пошло не так.'
    end
  end

  def become
    user = User.find_by_subdomain! params[:id]
    warden.set_user user

    redirect_to :root, :notice => "Вы стали пользователем '#{user.login}'"
  end

  def time_stats
  end
end
