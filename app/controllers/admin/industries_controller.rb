#encoding: utf-8
class Admin::IndustriesController < Admin::BaseController
  authorize_resource :industry

  def index
    @search = Industry.metasearch params[:search]
    @industries = @search.page params[:page]
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new params[:industry], as: :admin

    if @industry.save
      redirect_to admin_industries_path, :notice => 'Запись успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @industry = Industry.find params[:id]
  end

  def update
    @industry = Industry.find params[:id]

    if @industry.update_attributes params[:industry], as: :admin
     redirect_to :action => :index, :notice => 'Запись успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
