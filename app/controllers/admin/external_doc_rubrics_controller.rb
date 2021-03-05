#encoding: utf-8
class Admin::ExternalDocRubricsController < Admin::BaseController
  authorize_resource :external_doc_rubric

  def index
    @search = ExternalDocRubric.site(@site).metasearch params[:search]
    @external_doc_rubrics = @search.page params[:page]
  end

  def new
    @external_doc_rubric = @site.external_doc_rubrics.new
  end

  def create
    @external_doc_rubric = @site.external_doc_rubrics.new(params[:external_doc_rubric], as: :admin)

    if @external_doc_rubric.save
      redirect_to admin_external_doc_rubrics_path, notice: 'Запись успешно создана'
    else
      render action: :new
    end
  end

  def edit
    @external_doc_rubric = @site.external_doc_rubrics.find params[:id]
  end

  def update
    @external_doc_rubric = @site.external_doc_rubrics.find params[:id]

    if @external_doc_rubric.update_attributes params[:external_doc_rubric], as: :admin
     redirect_to action: :index, notice: 'Запись успешно обновлена'
    else
     render action: :edit
    end
  end

  def destroy
    @site.external_doc_rubrics.find(params[:id]).destroy
    redirect_to action: :index
  end
end
