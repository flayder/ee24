FactoryGirl.define do
  factory :tag, class: :'ActsAsTaggableOn::Tag' do
    site
    sequence(:name) { |n| "name-#{'a' * n}" }
  end
end
