#encoding: utf-8
class Admin::PhotoRubricsController < Admin::BaseController
  authorize_resource :photo_rubric

  def index
    @search = PhotoRubric.site(@site).metasearch params[:search]
    @photo_rubrics = @search.page params[:page]
  end

  def new
    @photo_rubric = PhotoRubric.new params[:photo_rubric], :as => :admin
    @photo_rubric.site = @site
  end

  def create
    @photo_rubric = @site.photo_rubrics.new params[:photo_rubric], :as => :admin

    if @photo_rubric.save
      redirect_to admin_photo_ubrics_path, :notice => 'Рубрика успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @photo_rubric = @site.photo_rubrics.find params[:id]
  end

  def update
    @photo_rubric = @site.photo_rubrics.find params[:id]

    if @photo_rubric.update_attributes params[:photo_rubric], :as => :admin
     redirect_to :action => :index, :notice => 'Словарная рубрика успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.photo_rubrics.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
