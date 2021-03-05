FactoryGirl.define do
  factory :forecast_widget, class: 'Forecast::Widget' do
    url { Faker::Internet.url }
    location { create :forecast_location }
    anchor { create :forecast_anchor }
  end
end
