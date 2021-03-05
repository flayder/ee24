FactoryGirl.define do
  factory :main_block_rubric do
    main_block
    rubric { create :news_rubric }
  end
end
