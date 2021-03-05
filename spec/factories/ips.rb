FactoryGirl.define do
  factory :ip do
    ip { Faker::Internet.ip_v4_address }
  end
end
