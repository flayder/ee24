# encoding : utf-8
FactoryGirl.define do
  factory :resume do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    contacts { Faker::Address.street_address }
    money { rand(1..100000).to_s }
    user
    industry
    profession_ids { [create(:profession).id] }
    created_at { DateTime.now }

    trait :approved do
      approved true
    end

    trait :with_photo do
      photos { [create(:board_photo)] }
    end
  end
end
