# encoding : utf-8
FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }
    password '12345678'
    password_confirmation '12345678'
    user_type 'user'
    confirm true
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.phone_number }
    site

    factory :user_with_avatar do
      avatar { File.open("#{Rails.root}/spec/fixtures/ava.jpg") }
    end

    factory :admin do
      user_type 'admin'
    end

    factory :moderator do
      user_type 'moderator'
    end

    factory :editor do
      user_type 'editor'
    end

    factory :observer do
      user_type 'observer'
    end

    trait :not_confirmed do
      confirm false
    end
  end
end
