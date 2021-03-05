# encoding : utf-8
FactoryGirl.define do
  factory :site do
    portal_title { Faker::Lorem.sentence }
    short_title { Faker::Lorem.word }
    sequence(:domain) { |n| "site_#{n}.ru" }
    sequence(:subdomain) { |n| "portal_#{n}" }
    map_provider 'yandex'
    active true
    sequence(:email) { |n| "site#{n}@example.com" }
    city

    factory :partner_site do
      is_partner true
    end

    factory :satellite do
      domain { "#{rand(98)+1}on.ru" }
    end

    factory :prague_site do
      domain '420on.cz'
    end
  end
end
