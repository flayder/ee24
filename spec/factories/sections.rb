# encoding : utf-8
FactoryGirl.define do
  factory :section do
    sequence(:position) { |n| n }
    title { Faker::Lorem.word }
    controller { Faker::Lorem.word }

    factory :docs_section do
      controller 'docs'
      in_sitemap true
    end

    factory :afisha_section do
      controller 'afisha'
      in_sitemap true
    end

    factory :catalog_section do
      controller 'catalog'
      in_sitemap true
    end

    factory :job_section do
      controller 'job'
      in_sitemap true
    end

    factory :photo_section do
      controller 'photo'
      in_sitemap true
    end

    factory :map_section do
      controller 'map'
      in_sitemap true
    end

    factory :dict_section do
      controller 'dictionary_objects'
      in_sitemap true
    end

    factory :weather_section do
      controller 'weather'
    end
  end
end
