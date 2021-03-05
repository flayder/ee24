# encoding : utf-8
FactoryGirl.define do
  factory :street do
    city
    title { Faker::Address.street_address }
  end
end
