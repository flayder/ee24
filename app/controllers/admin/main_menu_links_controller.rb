#encoding: utf-8
class Admin::MainMenuLinksController < Admin::BaseController
  authorize_resource :main_menu_link
  cache_sweeper :main_menu_link_sweeper

  def index
    @search = MainMenuLink.site(@site).metasearch params[:search]
    @main_menu_links = @search.page params[:page]
  end

  def new
    @main_menu_link = @site.main_menu_links.new
    @main_menu_link.site = @site
  end

  def create
    @main_menu_link = @site.main_menu_links.new params[:main_menu_link], as: :admin

    if @main_menu_link.save
      redirect_to admin_main_menu_links_path, notice: 'Запись успешно создана'
    else
      render action: :new
    end
  end

  def edit
    @main_menu_link = @site.main_menu_links.find params[:id]
  end

  def update
    @main_menu_link = @site.main_menu_links.find params[:id]

    if @main_menu_link.update_attributes params[:main_menu_link], as: :admin
     redirect_to action: :index, notice: 'Запись успешно обновлена'
    else
     render action: :edit
    end
  end

  def destroy
    @site.main_menu_links.find(params[:id]).destroy
    redirect_to action: :index
  end
end
