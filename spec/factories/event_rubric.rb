FactoryGirl.define do
  factory :event_rubric do
    title { Faker::Lorem.words(2).join(' ') }
    link { Faker::Lorem.word }
    site
  end
end
