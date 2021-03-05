# encoding : utf-8
FactoryGirl.define do
  factory :profession do
    title { Faker::Lorem.sentence }
    industry
  end
end
