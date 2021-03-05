FactoryGirl.define do
  factory :main_menu_link do
    title { Faker::Lorem.word }
    path { "/#{Faker::Lorem.word}" }
    position { rand(100) }
    site

    trait :highlighted do
      css_class { Faker::Lorem.word }
    end
  end
end
