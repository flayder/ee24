#encoding: utf-8
class Admin::SocialWidgetCodesController < Admin::BaseController
  authorize_resource :social_widget_code

  def index
    @social_widget_codes = @site.social_widget_codes
  end

  def new
    @social_widget_code = @site.social_widget_codes.new
  end

  def create
    @social_widget_code = @site.social_widget_codes.new params[:social_widget_code]

    if @social_widget_code.save
      flash[:notice] = 'Код успешно создан'
      redirect_to admin_social_widget_codes_path
    else
      render :action => :new
    end
  end

  def edit
    @social_widget_code = @site.social_widget_codes.find params[:id]
  end

  def update
    @social_widget_code = @site.social_widget_codes.find params[:id]

    if @social_widget_code.update_attributes params[:social_widget_code]
    flash[:notice] = 'Код успешно обновлён'
     redirect_to :action => :index
    else
     render :action => :edit
    end
  end

  def destroy
    @site.social_widget_codes.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
