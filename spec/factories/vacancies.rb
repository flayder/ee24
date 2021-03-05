FactoryGirl.define do
  factory :vacancy do
    industry
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    company_name { Faker::Company.name }
    contacts { Faker::Address.street_address }
    profession_ids { [create(:profession).id] }
    user
    catalog
    region_city
    region
    created_at { DateTime.now }

    trait :approved do
      approved true
    end

    trait :with_photo do
      photos { [create(:board_photo)] }
    end
  end
end
