class ForecastSubdomainConstraint
  def matches?(request)
    site = SiteFinder.find_site(request)
    site.has_section?('forecast/locations') &&
      !site.forecast_settings.subdomain.blank? &&
      request.subdomain == site.forecast_settings.subdomain &&
      Forecast::Data::AVAILABLE_DAYS.include?(request.params[:days_number])
  end
end
