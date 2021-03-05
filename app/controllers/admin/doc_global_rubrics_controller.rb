#encoding: utf-8
class Admin::DocGlobalRubricsController < Admin::BaseController
  authorize_resource :doc_global_rubric

  def index
    @search = DocGlobalRubric.site(@site).metasearch params[:search]
    @global_rubrics = @search.page params[:page]
  end

  def new
    @global_rubric = DocGlobalRubric.new
    @global_rubric.site = @site
  end

  def create
    @global_rubric = @site.doc_global_rubrics.new params[:doc_global_rubric], :as => :admin

    if @global_rubric.save
      redirect_to admin_doc_global_rubrics_path, :notice => 'Рубрика успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @global_rubric = @site.doc_global_rubrics.find params[:id]
  end

  def update
    @global_rubric = @site.doc_global_rubrics.find params[:id]

    if @global_rubric.update_attributes params[:doc_global_rubric], :as => :admin
     redirect_to :action => :index, :notice => 'Рубрика успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.doc_global_rubrics.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
