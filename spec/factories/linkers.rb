FactoryGirl.define do
  factory :linker do
    url { Faker::Internet.url }
    site
    seo_text { Faker::Lorem.sentence }
  end
end
