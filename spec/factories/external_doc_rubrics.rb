FactoryGirl.define do
  factory :external_doc_rubric do
    title { Faker::Lorem.sentence }
    site
  end
end
