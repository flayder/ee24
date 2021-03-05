# encoding : utf-8
class Admin::AdAgenciesController < Admin::BaseController
  authorize_resource :ad_agency

  def index
    @search = AdAgency.metasearch(params[:search])
    @ad_agencies = @search.page(params[:page])
  end

  def new
    @ad_agency = AdAgency.new
  end

  def create
    @ad_agency = AdAgency.new(params[:ad_agency], :as => :admin)

    if @ad_agency.save
      redirect_to admin_ad_agencys_path, :notice => 'Рекламное агенство успешно создано'
    else
      render :action => :new
    end
  end

  def edit
    @ad_agency = @AdAgency.find(params[:id])
  end

  def update
    @ad_agency = AdAgency.find(params[:id])

    if @ad_agency.update_attributes(params[:ad_agency], :as => :admin)
     redirect_to :action => :index, :notice => 'Рекламное агенство успешно обновлено'
    else
     render :action => :edit
    end
  end

  def destroy
    AdAgency.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
