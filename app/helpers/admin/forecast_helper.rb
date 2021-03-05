module Admin::ForecastHelper
  def icon_message(icon_name)
    data_message = Forecast::DataMessage.new
    data_message.message(icon_name)
  end
end
