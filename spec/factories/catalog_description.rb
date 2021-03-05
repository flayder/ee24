FactoryGirl.define do
  factory :catalog_description do
    catalog

    title { Faker::Lorem.words(2).join(' ') }
    annotation { Faker::Lorem.sentence }
    text { Faker::Lorem.sentences(3).join(' ') }
    language I18n.locale.to_s

  end
end
