# encoding : utf-8
FactoryGirl.define do
  factory :static_doc do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.sentences(3).join(' ') }
    site
    link { Faker::Lorem.word }
    meta_title { Faker::Lorem.sentence }
    meta_description { Faker::Lorem.sentences(3).join(' ') }
    meta_keywords { Faker::Lorem.words(10).join(', ') }

    factory :active_static_doc do
      active true
    end

    factory :main_static_doc do
      main true
    end
  end
end
