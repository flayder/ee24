# encoding : utf-8
class Admin::Design::StylesheetsController < Admin::BaseController
  authorize_resource :design_stylesheet, class: :'Design::Stylesheet'

  def index
    @search = ::Design::Stylesheet.site(@site).metasearch(params[:search])
    @stylesheets = @search.page(params[:page])
  end

  def new
    @stylesheet = @site.design_stylesheets.new
  end

  def create
    @stylesheet = @site.design_stylesheets.new(params[:design_stylesheet])

    if @stylesheet.save
      redirect_to admin_design_stylesheets_path, :notice => 'CSS успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @stylesheet = @site.design_stylesheets.find(params[:id])
  end

  def update
    @stylesheet = @site.design_stylesheets.find(params[:id])

    if @stylesheet.update_attributes(params[:design_stylesheet])
     redirect_to :action => :index, :notice => 'CSS успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    Design::Stylesheet.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
