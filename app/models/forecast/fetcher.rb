require 'nokogiri'

class Forecast::Fetcher
  BASE_URL = "http://http.foreca.com/feed/feed.php"

  DAY_FIELDS_DICTIONARY = {
    :max_temperature => 'tx',
    :min_temperature => 'tn',
    :wind_speed      => 'wsx',
    :wind_direction  => 'wn',
    :pressure        => 'p',
    :icon            => 's'
  }

  CURRENT_FIELDS_DICTIONARY = {
    :temperature     => 't',
    :wind_speed      => 'ws',
    :wind_direction  => 'wn',
    :pressure        => 'p',
    :icon            => 's',
    :humidity        => 'rh'
  }

  def initialize(site)
    @site = site
  end

  def fetch_districts_and_locations!
    locations = Nokogiri::XML Net::HTTP.get(URI.parse(forecast_url('36on-locations', '')))
    locations.xpath('//locations/loc').each do |location|
      district = @site.forecast_districts.find_or_create_by_name!(location.attr('adm1_ru'))

      district.locations.find_or_create_by_foreca_id!(location.attr('fca_id')) do |loc|
        loc.name = location.attr('name_ru')
        loc.lat = location.attr('lat')
        loc.lng = location.attr('lon')
      end
    end
  end

  def fetch_day!
    xml = Nokogiri::XML download_data('day')
    xml.xpath('//loc').each do |location_data|
      location = Forecast::Location.find_by_foreca_id location_data.attr('id')
      next unless location

      location_data.xpath('step').each do |day_data|

        timestamp = Time.parse day_data.attr('dt')
        forecast_data = location.datas.find_or_initialize_by_timestamp timestamp.beginning_of_day

        DAY_FIELDS_DICTIONARY.each_pair do |field, foreca_field|
          forecast_data.send(:"#{field}=", day_data.attr(foreca_field))
        end

        forecast_data.save!
      end
    end
  end

  def fetch_3hour!
    xml = Nokogiri::XML download_data('3hour')
    xml.xpath('//loc').each do |location_data|
      location = Forecast::Location.find_by_foreca_id location_data.attr('id')
      next unless location

      location_data.xpath('step').each do |day_data|
        timestamp = Time.parse day_data.attr('dt')
        forecast_data = location.datas.find_or_initialize_by_timestamp timestamp

        CURRENT_FIELDS_DICTIONARY.each_pair do |field, foreca_field|
          forecast_data.send(:"#{field}=", day_data.attr(foreca_field))
        end

        forecast_data.save!
      end
    end
  end

  def fetch_current!
    xml = Nokogiri::XML download_data('cc')

    xml.xpath('//loc').each do |location_data|
      location = Forecast::Location.find_by_foreca_id location_data.attr('id')

      next unless location

      location_data.xpath('step').each do |day_data|
        timestamp = Time.parse day_data.attr('dt')
        forecast_data = location.datas.find_or_initialize_by_timestamp timestamp

        CURRENT_FIELDS_DICTIONARY.each_pair do |field, foreca_field|
          forecast_data.send(:"#{field}=", day_data.attr(foreca_field))
        end

        forecast_data.save
      end
    end
  end

  private
  def unzip body
    gzip = Zlib::GzipReader.new body
    gzip.read
  end

  def download_data type
    unzip StringIO.new(Net::HTTP.get(URI.parse(forecast_url(type))))
  end

  def forecast_url type, format = '.gz'
    BASE_URL + "/#{type}.xml#{format}?user=#{@site.forecast_settings.login}&pass=#{@site.forecast_settings.password}"
  end
end
