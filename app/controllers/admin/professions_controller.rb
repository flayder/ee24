#encoding: utf-8
class Admin::ProfessionsController < Admin::BaseController
  authorize_resource :profession

  def index
    @search = Profession.metasearch params[:search]
    @professions = @search.page params[:page]
  end

  def new
    @profession = Profession.new industry_id: params[:industry_id]
  end

  def create
    @profession = Profession.new params[:profession], :as => :admin

    if @profession.save
      redirect_to admin_professions_path, :notice => 'Запись успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @profession = Profession.find params[:id]
  end

  def update
    @profession = Profession.find params[:id]

    if @profession.update_attributes params[:profession], :as => :admin
     redirect_to :action => :index, :notice => 'Запись успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    Profession.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
