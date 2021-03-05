# encoding : utf-8
FactoryGirl.define do
  factory :site_admin do
    site
    user
    role 'admin'
    
    factory :site_editor do
      role 'editor'
    end

    factory :site_moderator do
      role 'moderator'
    end

    factory :site_observer do
      role 'observer'
    end
  end
end
