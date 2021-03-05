# encoding : utf-8
FactoryGirl.define do
  factory :ad_agency do
    title { Faker::Lorem.sentence }
  end
end
