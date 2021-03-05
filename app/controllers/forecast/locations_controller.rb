class Forecast::LocationsController < ApplicationController
  layout "weather"

  before_filter :check_redirect, only: :show

  def show
    location = Forecast::Location.site_location(@site, params[:location_id])

    # TODO refactor with Facade pattern
    @current_data = location.datas.today.current.timestamp_gt(Time.now).order('timestamp ASC').first

    @morning_data = location.datas.today.timestamp_gt(Time.now.beginning_of_day).order('timestamp ASC').first
    @midday_data = location.datas.today.timestamp_gt(Time.now.noon).order('timestamp ASC').first
    @evening_data = location.datas.today.timestamp_gt(Time.now).order('timestamp DESC').first

    @datas = location.datas.where('DATE(timestamp) IN (?)', (Date.today..(Date.today - 2 + num_of_days.days))).where('min_temperature IS NOT NULL').group('DATE(timestamp)')
  end

  private
  def check_redirect
    if params[:l] && params[:n]
      redirect_to forecast_location_forecast_path(
        location_id: params[:l],
        days_number: params[:n]
      )
    end
  end

  def num_of_days
    params[:days_number][/\d+/].to_i
  end
end
