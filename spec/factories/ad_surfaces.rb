# encoding : utf-8
FactoryGirl.define do
  factory :ad_surface do
    ad_agency
    ad_format
    city
    street
    title { Faker::Lorem.word }
    address '1'
    description { Faker::Lorem.words(10).join(' ') }
  end
end
