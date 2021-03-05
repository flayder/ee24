FactoryGirl.define do
  factory :dictionary_rubric do
    title { Faker::Lorem.words(2).join(' ') }
    site
  end
end
