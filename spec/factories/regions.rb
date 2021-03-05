# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :region do
    sequence(:title) { |n| "region_#{n}" }
  end
end
