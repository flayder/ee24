# encoding : utf-8
class Admin::Design::TemplatesController < Admin::BaseController
  authorize_resource :design_template, class: :'Design::Template'

  def index
    @search = ::Design::Template.site(@site).metasearch(params[:search])
    @templates = @search.page(params[:page])
  end

  def new
    @template = @site.design_templates.new
  end

  def create
    @template = @site.design_templates.new(params[:design_template])

    if @template.save
      redirect_to admin_design_templates_path, :notice => 'Темплейт успешно создан'
    else
      render :action => :new
    end
  end

  def edit
    @template = @site.design_templates.find(params[:id])
  end

  def update
    @template = @site.design_templates.find(params[:id])

    if @template.update_attributes(params[:design_template])
     redirect_to :action => :index, :notice => 'Темплейт успешно обновлен'
    else
     render :action => :edit
    end
  end

  def destroy
    Design::Template.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
