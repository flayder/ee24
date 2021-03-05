# require 'em-synchrony'
# require "em-synchrony/em-http"
# require 'em-synchrony/fiber_iterator'
# require 'nokogiri'

# namespace :sites do

#     task :download_timezone => :environment do
#       EM.synchrony do
#         CONCURRENCY = 10

#         EM::Synchrony::FiberIterator.new(City.all, CONCURRENCY).each do |city|
#           next unless city.site
          
#           http_data = EM::HttpRequest.new("http://www.earthtools.org/timezone/#{city.lat}/#{city.lng}").get        
#           if http_data.response && !http_data.response.empty?
#             time_zone_xml = Nokogiri::XML http_data.response

#             if time_zone = time_zone_xml.xpath('//offset').first.try(:text)
#               city.site.update_attribute :time_zone, time_zone
#             end
#           end
#         end

#         EM.stop
#       end
#     end

# end
