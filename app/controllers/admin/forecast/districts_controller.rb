# encoding : utf-8
class Admin::Forecast::DistrictsController < Admin::BaseController
  authorize_resource :forecast_district, class: 'Forecast::District'

  def edit
    @districts = @site.forecast_districts
  end

  def update
    if set_active_districts
      redirect_to action: :edit, notice: 'Районы Foreca обновлены'
    else
      render action: :edit
    end
  end

  private
  def set_active_districts
    districts = @site.forecast_districts.where(id: params[:district_ids])

    Forecast::District.transaction do
      districts.update_all(active: true)
      @site.forecast_districts.where('id NOT IN (?)', districts).update_all(active: false)
    end
  end
end
