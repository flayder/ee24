FactoryGirl.define do
  factory :ad_code do
    site
    code { Faker::Lorem.sentences(3).join(' ') }
    banner_type { AdCode::BANNER_TYPES.sample }
    title { Faker::Lorem.word }
    ad_section { create :site_section }
  end
end
