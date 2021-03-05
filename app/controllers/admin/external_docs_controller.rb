# encoding: utf-8
class Admin::ExternalDocsController < Admin::BaseController
  authorize_resource :external_doc
  cache_sweeper :external_doc_sweeper

  def index
    @external_docs = @site.external_docs
  end

  def new
    @external_doc = @site.external_docs.new
  end

  def edit
    @external_doc = @site.external_docs.find(params[:id])
  end

  def create
    @external_doc = @site.external_docs.build(params[:external_doc], as: :admin)
    @external_doc.user = current_user

    if @external_doc.save
      redirect_to action: :index, notice: 'Внешняя ссылка успешно создана.'
    else
      render action: :new
    end
  end

  def update
    @external_doc = @site.external_docs.find(params[:id])

    if @external_doc.update_attributes(params[:external_doc], as: :admin)
     redirect_to action: :index, notice: 'Внешняя ссылка успешно обновлена.'
    else
     render action: :edit
    end
  end

  def destroy
    ExternalDoc.destroy(params[:id])

    redirect_to :back, notice: "Внешняя ссылка была успешно удалена."
  end
end
