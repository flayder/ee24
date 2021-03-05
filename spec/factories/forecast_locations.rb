FactoryGirl.define do
  factory :forecast_location, class: 'Forecast::Location' do
    name { Faker::Address.city }
    district { create :forecast_district }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    foreca_id { rand(1000000000..100000000000).to_s }
  end
end
