#encoding: utf-8
class Admin::CatalogRubricsController < Admin::BaseController
  authorize_resource :catalog_rubric

  def index
    @search = CatalogRubric.site(@site).metasearch params[:search]
    @catalog_rubrics = @search.page params[:page]
  end

  def new
    @catalog_rubric = CatalogRubric.new params[:catalog_rubric], :as => :admin
    @catalog_rubric.site = @site
  end

  def create
    @catalog_rubric = @site.catalog_rubrics.new params[:catalog_rubric], :as => :admin

    if @catalog_rubric.save
      redirect_to admin_catalog_rubrics_path, :notice => 'Рубрика успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @catalog_rubric = @site.catalog_rubrics.find params[:id]
  end

  def update
    @catalog_rubric = @site.catalog_rubrics.find params[:id]

    if @catalog_rubric.update_attributes(params[:catalog_rubric], :as => :admin)
     redirect_to :action => :index, :notice => 'Рубрика успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.catalog_rubrics.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
