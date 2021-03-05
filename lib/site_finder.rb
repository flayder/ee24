# encoding : utf-8
module SiteFinder
  def self.find_site(request)
    if Settings['default_host_name']
      host_name = Settings.default_host_name
    elsif request.subdomain == 'divmaxx'
      host_name = 'divmaxx.ru'
    else
      host_name = request.domain
    end

    Site.find_by_domain!(host_name)
  end
end
