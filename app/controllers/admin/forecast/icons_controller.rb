#encoding: utf-8
class Admin::Forecast::IconsController < Admin::BaseController
  authorize_resource :forecast_icon, class: 'Forecast::Icon'

  def index
    @forecast_icons = @site.forecast_icons.page(params[:page])
  end

  def edit
    @forecast_icon = @site.forecast_icons.find params[:id]
  end

  def update
    @forecast_icon = @site.forecast_icons.find params[:id]

    if @forecast_icon.update_attributes params[:forecast_icon], as: :admin
     redirect_to action: :index, :notice => 'Запись успешно обновлена'
    else
     render action: :edit
    end
  end
end
