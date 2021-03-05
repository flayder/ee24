FactoryGirl.define do
  factory :search_query do
    query { Faker::Lorem.word }
    site
  end
end