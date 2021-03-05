FactoryGirl.define do
  factory :doc_global_rubric do
    title { Faker::Lorem.words(2).join(' ') }
    sequence(:link) { |n| "#{Faker::Lorem.word}_#{n}" }
    site
  end
end
