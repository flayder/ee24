require 'nokogiri'

module CleanWeb
  class Checker
    API_URL = 'http://cleanweb-api.yandex.ru/1.0/check-spam'
    RESPONSE_BOOLEAN = { 'yes' => true, 'no' => false }

    def initialize
      @params = {
        :key => Settings.yandex_cleanweb_api_key
      }
    end

    def check title, body
      @params[:'subject-plain'] = title
      @params[:'body-plain'] = body
      response = get_response

      if response.code == '200'
        begin
          xml = Nokogiri::XML(response.body)
          RESPONSE_BOOLEAN[xml.xpath('//check-spam-result/text').first[:'spam-flag']]
        rescue Exception => e
          # Airbrake.notify e
          nil
        end
      else
        # Airbrake.notify "ERROR WHEN SPAM FILTERING #{response.body}"
        nil
      end
    end

    private
    def get_response
      uri = URI.parse API_URL
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)

      request.set_form_data @params
      http.request request
    end
  end
end
