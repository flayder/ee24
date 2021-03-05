# encoding : utf-8
FactoryGirl.define do
  factory :dictionary do
    link { Faker::Lorem.word }
    site
    description { Faker::Lorem.sentence }
    title { Faker::Lorem.sentence }
  end
end
