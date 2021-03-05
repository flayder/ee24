FactoryGirl.define do
  factory :rubric_permission do
    rubric { create :doc_rubric }
    site_admin
  end

  factory :external_doc_rubric_permission do
    rubric { create :external_doc_rubric }
    site_admin
  end
end
