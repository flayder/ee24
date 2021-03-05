class ForecastsAvailableDaysConstraint
  def matches?(request)
    site = SiteFinder.find_site(request)
    if site.forecast_settings.subdomain.blank?
      site.has_section?('forecast/locations') &&
        Forecast::Data::AVAILABLE_DAYS.include?(request.params[:days_number])
    else
      site.has_section?('forecast/locations') &&
        Forecast::Data::AVAILABLE_DAYS.include?(request.params[:days_number]) &&
        request.subdomain == site.forecast_settings.subdomain
    end
  end
end
