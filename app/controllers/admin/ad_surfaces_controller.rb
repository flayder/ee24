# encoding : utf-8
class Admin::AdSurfacesController < Admin::BaseController
  authorize_resource :ad_surface

  def index
    @search = AdSurface.metasearch(params[:search])
    @ad_surfaces = @search.page(params[:page])
  end

  def new
    @ad_surface = AdSurface.new
  end

  def create
    @ad_surface = AdSurface.new(params[:ad_surface], :as => :admin)

    if @ad_surface.save
      redirect_to admin_ad_surfaces_path, :notice => 'Рекламная поверхность успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @ad_surface = AdSurface.find(params[:id])
  end

  def update
    @ad_surface = AdSurface.find(params[:id])

    if @ad_surface.update_attributes(params[:ad_surface], :as => :admin)
     redirect_to :action => :index, :notice => 'Рекламная поверхность успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    AdSurface.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
