# encoding: utf-8
require 'digest/md5'

FactoryGirl.define do
  factory :mobile_device do
    # Токен устройства должен содержать 64 символа.
    token Digest::MD5.hexdigest(Faker::Lorem.word) + Digest::MD5.hexdigest(Faker::Lorem.word)
    site { site }
  end
end
