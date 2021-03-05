module Forecast::LocationsHelper
  def menu
    Forecast::Location.for_menu(@site).map do |location|
      Forecast::Data::AVAILABLE_DAYS.map do |days_number|
        link_to(
          location.name, forecast_location_forecast_url(
          subdomain: @site.forecast_settings.subdomain.squash,
          days_number: days_number,
          location_id: location.param
        ),
          class: "c-#{days_number}"
        )
      end.join('').html_safe
    end.join('').html_safe
  end
end
