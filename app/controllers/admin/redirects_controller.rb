#encoding: utf-8
class Admin::RedirectsController < Admin::BaseController
  authorize_resource :redirect

  def index
    @search = Redirect.site(@site).metasearch params[:search]
    @redirects = @search.page params[:page]
  end

  def new
    @redirect = Redirect.new
    @redirect.site = @site
  end

  def create
    @redirect = @site.redirects.build params[:redirect]

    if @redirect.save
      redirect_to admin_redirects_path, :notice => 'Редирект успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @redirect = @site.redirects.find params[:id]
  end

  def update
    @redirect = @site.redirects.find params[:id]

    if @redirect.update_attributes params[:redirect]
     redirect_to :action => :index, :notice => 'Редирект успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.redirects.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
