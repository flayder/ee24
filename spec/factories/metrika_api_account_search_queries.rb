FactoryGirl.define do
  factory :metrika_api_account_search_query, class: 'MetrikaApiAccount::SearchQuery' do
    body { Faker::Lorem.sentence }
    page_views { rand(1000) }
    visits { rand (1000) }
    url { create :metrika_api_account_url }
  end
end
