FactoryGirl.define do
  factory :message do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    sender { create :user }
    receiver { create :user }
  end
end
