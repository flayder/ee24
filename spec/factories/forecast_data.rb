FactoryGirl.define do
  factory :forecast_data, class: 'Forecast::Data' do
    timestamp { Time.now }
    temperature { rand(10) }
    icon { ForecastHelper::ICONS.keys.sample }
    pressure { rand(750..770) }
    wind_speed { rand(10) }
    location { create :forecast_location }
  end
end
