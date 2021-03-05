FactoryGirl.define do
  factory :doc_rubric do
    title { Faker::Lorem.words(2).join(' ') }
    sequence(:link) { |n| "#{Faker::Lorem.word}_#{n}" }
    global_rubric { create :doc_global_rubric }
    site
  end
end
