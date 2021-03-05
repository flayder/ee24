# encoding : utf-8
FactoryGirl.define do
  factory :gallery do
    title { Faker::Lorem.words(rand(3) + 1).join(' ') }
    annotation { Faker::Lorem.sentence }
    photo_rubric
    site
    user

    after(:create) { |g| g.photos << create(:photo, photo: g) }
  end

  trait :approved do
    approved true
  end
end
