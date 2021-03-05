# encoding : utf-8
class Admin::Forecast::SettingsController < Admin::BaseController
  authorize_resource :forecast_settings, class: 'Forecast::Settings'

  def edit
    @settings = @site.forecast_settings
  end

  def update
    settings = @site.forecast_settings

    if @site.forecast_settings.update_attributes(params[:forecast_settings])
     redirect_to action: :edit, notice: 'Настройки Foreca обновлены'
    else
     render action: :edit
    end
  end
end
