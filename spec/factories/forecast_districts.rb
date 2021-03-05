FactoryGirl.define do
  factory :forecast_district, class: 'Forecast::District' do
    name { Faker::Address.city }
    site
  end
end
