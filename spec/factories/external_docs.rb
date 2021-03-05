# encoding : utf-8
FactoryGirl.define do
  factory :external_doc do
    sequence(:title) { |i| "#{Faker::Lorem.sentence} #{i}" }
    url { Faker::Internet.url }
    main false
    rubric { create :external_doc_rubric }
    site
    user
    image { File.open("#{Rails.root}/spec/fixtures/ava.jpg") }

    trait :approved do
      approved true
    end

    trait :main do
      main true
    end
  end
end
