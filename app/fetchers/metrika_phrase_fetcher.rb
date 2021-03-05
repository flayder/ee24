require 'em-synchrony'
require "em-synchrony/em-http"
require 'em-synchrony/fiber_iterator'
require 'net/http'
require 'json'

class MetrikaPhraseFetcher < Struct.new(:site)
  GOOGLE_SE_ID = 3
  CONCURRENCY = 10

  def fetch_phrases
    site.metrika_api_account.urls.delete_all

    request = Net::HTTP.get_response(url).body
    data = extract_data request

    rows = JSON.parse(request)['rows']
    pages = rows / 100 + 1

    EM.synchrony do
      EM::Synchrony::FiberIterator.new((1..pages), CONCURRENCY).each do |page|
        offset = page * 100 + 1

        n_tries = 1
        begin
          http_data = EM::HttpRequest.new(url(offset)).get        
          extract_data(http_data.response) if http_data.response && !http_data.response.empty?
        rescue
          n_tries += 1
          retry if n_tries < 3
        end
      end

      EM.stop
    end
  end

  private
  def metrika_api_account
    site.metrika_api_account
  end

  def token
    metrika_api_account.token
  end

  def counter_id
    metrika_api_account.counter_id
  end

  def extract_url data
    if google_result = data['search_engines'].find{ |se| se['se_id'] == GOOGLE_SE_ID }
      CGI.parse(google_result['se_url'])['url'].first
    end 
  end

  def url offset = 0
    URI "http://api-metrika.yandex.ru/stat/sources/phrases?date1=#{(Date.today - 1.month).to_s(:for_metrika)}&date2=#{Date.today.to_s(:for_metrika)}&group=day&id=#{counter_id}&offset=#{offset}&oauth_token=#{token}&format=json"
  end

  def extract_data http_data
    JSON.parse(http_data)['data'].each do |phrase|
      url = metrika_api_account.urls.find_or_create_by_body extract_url(phrase)
      
      url.search_queries.find_or_create_by_body(phrase['phrase']) do |sq|
        sq.page_views = phrase['page_views']
        sq.visits = phrase['visits']  
      end
    end
  end
end