class ExchangeRate < ActiveRecord::Base
  validates_presence_of :date_of_rate

  def self.load_current_exchange_rates
    date_of_rate = Date.current
    exchange_rate = ExchangeRate.find_by_date_of_rate(date_of_rate) || ExchangeRate.new(date_of_rate: date_of_rate)
    need_update = false
    ['eur_czk', 'usd_czk', 'rub_czk', 'uah_czk'].each do |rate|
      uri = URI("http://free.currencyconverterapi.com/api/v6/convert?q=#{rate}&compact=ultra&apiKey=#{Settings['currencyconver_apikey']}")
      response = Net::HTTP.get_response(uri)
      if response.code == '200'
        json = JSON.parse(response.body)
        data = json["#{rate.upcase}"]
        exchange_rate["#{rate}_rate"] = data if data.present?
        need_update = true
      end
    end
    exchange_rate.save if need_update
  end
end
