# encoding : utf-8
class Admin::LinkersController < Admin::BaseController
  authorize_resource :linker

  def index
    @search = Linker.site(@site).metasearch(params[:search])
    @linkers = @search.page(params[:page])
  end

  def new
    @linker = Linker.new
  end

  def create
    @linker = @site.linkers.new(params[:linker], as: :admin)

    if @linker.save
      redirect_to admin_linkers_path, :notice => 'Линкер успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @linker = @site.linkers.find(params[:id])
  end

  def update
    @linker = @site.linkers.find(params[:id])

    if @linker.update_attributes(params[:linker], as: :admin)
     redirect_to :action => :index, :notice => 'Линкер успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.linkers.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
