# encoding : utf-8
FactoryGirl.define do
  factory :web_analytics_block do
    body { Faker::Lorem.sentence }
    code_type 'liveinternet'
    site
  end
end
