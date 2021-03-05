# encoding : utf-8
class Admin::StaticDocsController < Admin::BaseController
  authorize_resource :static_doc

  def index
    @search = StaticDoc.site(@site).metasearch(params[:search])
    @static_docs = @search.page(params[:page])
  end

  def new
    @static_doc = @site.static_docs.build(params[:static_doc])
  end

  def create
    @static_doc = @site.static_docs.new(params[:static_doc], :as => :admin)

    if @static_doc.save
      redirect_to admin_static_docs_path, :notice => 'Статичная страница успешно создана.'
    else
      render :action => :new
    end
  end

  def edit
    @static_doc = @site.static_docs.find(params[:id])
  end

  def update
    @static_doc = @site.static_docs.find(params[:id])

    if @static_doc.update_attributes(params[:static_doc], :as => :admin)
      redirect_to :action => :index, :notice => 'Статичная страница успешно обновлена.'
    else
      render :action => :edit
    end
  end

  def destroy
    @site.static_docs.find(params[:id]).destroy
    redirect_to :action => :index, :notice => 'Статичная страница успешно удалена.'
  end
end
