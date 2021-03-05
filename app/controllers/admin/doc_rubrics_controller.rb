#encoding: utf-8
class Admin::DocRubricsController < Admin::BaseController
  authorize_resource :doc_rubric

  def index
    @search = DocRubric.site(@site).metasearch params[:search]
    @doc_rubrics = @search.page params[:page]
  end

  def new
    @doc_rubric = DocRubric.new params[:doc_rubric], :as => :admin
    @doc_rubric.site = @site
  end

  def create
    @doc_rubric = @site.doc_rubrics.new params[:doc_rubric], :as => :admin

    if @doc_rubric.save
      redirect_to admin_doc_rubrics_path, :notice => 'Статейная рубрика успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @doc_rubric = @site.doc_rubrics.find params[:id]
  end

  def update
    @doc_rubric = @site.doc_rubrics.find params[:id]

    if @doc_rubric.update_attributes params[:doc_rubric], :as => :admin
      redirect_to :action => :index, :notice => 'Статейная рубрика успешно обновлена'
    else
      render :action => :edit
    end
  end

  def destroy
    @site.doc_rubrics.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
