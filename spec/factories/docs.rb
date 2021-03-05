# encoding : utf-8
FactoryGirl.define do
  factory :doc do
    sequence(:title) { |i| "#{Faker::Lorem.sentence} #{i}" }
    annotation { Faker::Lorem.sentence }
    text { Faker::Lorem.sentences(3).join(' ') }
    main false
    rubric { create :doc_rubric }
    site
    user
    created_at { DateTime.now }

    trait :approved do
      approved true
    end

    trait :main do
      main true
    end

    factory :double_migrated_doc do
      news_doc_doc_id { rand(2000) }
      news_doc_id { rand(2000) }
    end

    factory :migrated_once_doc do
      news_doc_id { rand(2000) }
    end
  end
end
