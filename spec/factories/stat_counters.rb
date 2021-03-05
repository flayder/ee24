FactoryGirl.define do
  factory :stat_counter do
    model 'Doc'
    count { rand (100500) }
    date { rand(2.years).from_now.to_date }
    site
  end
end
