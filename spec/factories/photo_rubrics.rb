FactoryGirl.define do
  factory :photo_rubric do
    title { Faker::Lorem.words(rand(3) + 1).join(' ') }
    link { Faker::Lorem.word }
    site
  end
end
