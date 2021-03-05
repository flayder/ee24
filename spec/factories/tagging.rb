FactoryGirl.define do
  factory :tagging, class: :'ActsAsTaggableOn::Tagging' do
    tag
    taggable { create :doc }
    context 'tags'
  end
end
