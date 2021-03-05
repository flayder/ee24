FactoryGirl.define do
  factory :forecast_settings, class: 'Forecast::Settings' do
    site
    login { Faker::Lorem.word }
    password { Faker::Lorem.word }
  end
end
