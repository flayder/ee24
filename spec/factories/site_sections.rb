# encoding : utf-8
FactoryGirl.define do
  factory :site_section do
    site
    section
    
    factory :partner_site_section do
      site { create :partner_site }
    end

    factory :news_site_section do
      section { create :news_section }
    end
  end
end
