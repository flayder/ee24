# encoding : utf-8
class Admin::AdFormatsController < Admin::BaseController
  authorize_resource :ad_format

  def index
    @search = AdFormat.metasearch(params[:search])
    @ad_formats = @search.page(params[:page])
  end

  def new
    @ad_format = AdFormat.new
  end

  def create
    @ad_format = AdFormat.new(params[:ad_format], :as => :admin)

    if @ad_format.save
      redirect_to admin_ad_formats_path, :notice => 'Формат рекламной поверхности успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @ad_format = AdFormat.find(params[:id])
  end

  def update
    @ad_format = AdFormat.find(params[:id], :as => :admin)

    if @ad_format.update_attributes(params[:ad_format])
     redirect_to :action => :index, :notice => 'Формат рекламной поверхности успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    AdFormat.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
