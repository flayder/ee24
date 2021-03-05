FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.words(2).join(' ') }
    annotation { Faker::Lorem.sentence }
    text { Faker::Lorem.sentences(3).join(' ') }
    address { Faker::Address.street_address }
    start_date { (rand(2.years) - 1.year).ago }
    finish_date { rand(1.years).ago }
    site
    rubric { create :event_rubric }
    user

    trait :approved do
      approved true
    end
  end
end
