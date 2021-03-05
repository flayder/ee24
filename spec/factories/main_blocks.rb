FactoryGirl.define do
  factory :main_block do
    doc_type 'Doc'
    site
    title { Faker::Lorem.word }
    path { "/#{Faker::Lorem.word}" }

    trait :external_doc do
      doc_type 'ExternalDoc'
      path { Faker::Internet.url }
    end
  end
end
