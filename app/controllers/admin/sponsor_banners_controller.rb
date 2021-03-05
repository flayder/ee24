# encoding : utf-8
class Admin::SponsorBannersController < Admin::BaseController
  authorize_resource :sponsor_banner

  def index
    @search = SponsorBanner.site(@site).metasearch(params[:search])
    @sponsor_banners = @search.page(params[:page])
  end

  def new
    @sponsor_banner = SponsorBanner.new
  end

  def create
    @sponsor_banner = @site.sponsor_banners.new(params[:sponsor_banner], :as => :admin)

    if @sponsor_banner.save
      redirect_to admin_sponsor_banners_path, :notice => 'Спонсорский баннер успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @sponsor_banner = @site.sponsor_banners.find(params[:id])
  end

  def update
    @sponsor_banner = @site.sponsor_banners.find(params[:id])

    if @sponsor_banner.update_attributes(params[:sponsor_banner], :as => :admin)
     redirect_to :action => :index, :notice => 'Спонсорский баннер успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.sponsor_banners.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
