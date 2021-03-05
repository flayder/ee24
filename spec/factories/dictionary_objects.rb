# encoding : utf-8
FactoryGirl.define do
  factory :dictionary_object do
    title { Faker::Lorem.words(2).join(' ') }
    # there should be no type
    # types are used only on 36on.ru
    letter { title.chars.first }
    text { Faker::Lorem.sentence }
    site
    rubric { create :dictionary_rubric, :site => site }

    trait :approved do
      approved true
    end
  end
end
