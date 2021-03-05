# encoding : utf-8
FactoryGirl.define do
  factory :social_widget_code do
    code { Faker::Lorem.sentence }
    widget_type 'vk'
    site
  end
end
