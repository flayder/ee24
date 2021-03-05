FactoryGirl.define do
  factory :forecast_anchor, class: 'Forecast::Anchor' do
    text { Faker::Lorem.sentence }
    limit { rand(100) }
  end
end
