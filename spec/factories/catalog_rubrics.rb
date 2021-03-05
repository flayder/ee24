FactoryGirl.define do
  factory :catalog_rubric do
    title { Faker::Lorem.words(2).join(' ') }
    sequence(:position) { |n| n }
    site
  end
end