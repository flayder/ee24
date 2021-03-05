# encoding : utf-8
class Admin::SeosController < Admin::BaseController
  authorize_resource :seo

  def index
    @search = Seo.site(@site).metasearch(params[:search])
    @seos = @search.order('(path is null or path = "") desc').page(params[:page])
  end

  def new
    @seo = Seo.new params[:seo], as: :admin
  end

  def create
    @seo = @site.seos.new(params[:seo], as: :admin)

    if @seo.save
      redirect_to admin_seos_path, :notice => 'SEO текст успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @seo = @site.seos.find(params[:id])
  end

  def update
    @seo = @site.seos.find(params[:id])

    if @seo.update_attributes(params[:seo], as: :admin)
      redirect_to :action => :index, :notice => 'SEO текст успешно обновлен'
    else
      render :action => :edit
    end
  end

  def destroy
    @site.seos.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
