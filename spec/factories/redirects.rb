FactoryGirl.define do
  factory :redirect do
    from { Faker::Internet.url }
    to { Faker::Internet.url }
    site
  end
end
