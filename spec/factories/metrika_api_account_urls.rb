FactoryGirl.define do
  factory :metrika_api_account_url, class: 'MetrikaApiAccount::Url' do
    body { Faker::Internet.url }
    metrika_api_account
  end
end
