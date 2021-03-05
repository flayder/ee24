FactoryGirl.define do
  factory :seo do
    title { Faker::Lorem.word }
    about { Faker::Lorem.sentences(3).join(' ') }
    description { Faker::Lorem.sentences(3).join(' ') }
    keywords { Faker::Lorem.words(10).join(', ') }
    text { Faker::Lorem.sentences(3).join(' ') }
    site
    seo { create :doc_rubric }
    
    factory :with_path do
      path "/#{Faker::Lorem.word}"
    end

    factory :rubric_doc_seo do
      seo { create :doc_rubric }
    end
  end
end