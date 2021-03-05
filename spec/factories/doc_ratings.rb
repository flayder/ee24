FactoryGirl.define do
  factory :doc_rating do
    user
    ratable { create :doc }
    value 1
  end
end
