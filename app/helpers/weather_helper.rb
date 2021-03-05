# encoding : utf-8
require 'open-uri'
require 'json'
require 'psych'

module WeatherHelper
  WEATHER_CITY = 'prague,cz'
  CITY_ID = '3067696'

  def get_current_weather
    Rails.cache.fetch 'openweathermap', expires_in: 1.hour do
      request = "https://api.openweathermap.org/data/2.5/weather?id=#{CITY_ID}&APPID=#{Settings.openweathermap_key}&mode=json&units=metric&lang=ru"
      JSON.parse(open(request).readlines.join) rescue return nil
    end
  end

  def get_forecast_weather
    request = "https://api.openweathermap.org/data/2.5/forecast/daily?id=#{CITY_ID}&APPID=#{Settings.openweathermap_key}&mode=json&cnt=14&units=metric&lang=ru"
    JSON.parse(open(request).readlines.join) rescue return nil
  end

  def get_icon_url(weather)
    "https://openweathermap.org/img/w/#{weather['weather'][0]['icon']}.png" if weather['weather']
  end
end
