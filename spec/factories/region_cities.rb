# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :region_city do
    title { Faker::Lorem.word }
    region
  end
end
