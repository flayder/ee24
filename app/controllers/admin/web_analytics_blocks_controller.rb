# encoding : utf-8
class Admin::WebAnalyticsBlocksController < Admin::BaseController
  authorize_resource :web_analytics_block

  def index
    @web_analytics_blocks = @site.web_analytics_blocks
  end

  def show
    @web_analytics_block = @site.web_analytics_blocks.find(params[:id])
  end

  def new
    @web_analytics_block = @site.web_analytics_blocks.new
  end

  def create
    @web_analytics_block = @site.web_analytics_blocks.new(params[:web_analytics_block])
    if @web_analytics_block.save
      flash[:notice] = 'Код счетчика сохранён'
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @web_analytics_block = @site.web_analytics_blocks.find(params[:id])
  end

  def update
    @web_analytics_block = @site.web_analytics_blocks.find(params[:id])
    if @web_analytics_block.update_attributes(params[:web_analytics_block])
      flash[:notice] = 'Код счетчика успешно обновлен'
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @web_analytics_block = @site.web_analytics_blocks.find(params[:id])
    flash[:notice] = 'Код успешно удалён' if @web_analytics_block.destroy
    redirect_to :action => :index
  end

end
