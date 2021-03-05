FactoryGirl.define do
  factory :catalog do
    ignore do
      rubric nil
    end

    email { Faker::Internet.email }
    site_url { Faker::Internet.url }
    postal_code { Faker::Address.postcode }
    extended_address { Faker::Address.secondary_address }
    tel { Faker::PhoneNumber.phone_number }
    fax { Faker::PhoneNumber.phone_number }
    region_extension { Faker::Address.state }
    locality { Faker::Address.city }
    street_address { Faker::Address.street_address }
    site
    user

    trait :with_editor_fields do
      contact { Faker::Lorem.sentence }
      meta_title { Faker::Lorem.sentence }
      meta_keywords { Faker::Lorem.words(4).join(', ') }
      meta_description { Faker::Lorem.sentence }
      position { rand(0..100) }
    end

    trait :approved do
      approved true
    end
    before(:create) do |catalog, evaluator|
      catalog.rubrics << (evaluator.rubric.nil? ? FactoryGirl.create(:catalog_rubric, site: evaluator.site) : evaluator.rubric)
    end
    after(:create) do |catalog, evaluator|
      create :catalog_description, catalog: catalog
    end
  end
end
