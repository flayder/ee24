FactoryGirl.define do
  factory :black_list_word do
    lemma { Faker::Lorem.word }
  end
end
