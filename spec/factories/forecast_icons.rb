FactoryGirl.define do
  factory :forecast_icon, class: 'Forecast::Icon' do
    site
    name { ForecastHelper::ICONS.values.sample }
  end
end
