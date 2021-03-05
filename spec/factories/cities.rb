# encoding : utf-8
FactoryGirl.define do
  factory :city do
    title 'Прага'
    link 'prague'

    factory :prague_city do
      link 'prague'
    end
  end
end
