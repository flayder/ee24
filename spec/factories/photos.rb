# encoding : utf-8
FactoryGirl.define do
  factory :photo do
    title { Faker::Lorem.sentence }
    photo { create :doc }

    factory :doc_photo do
      photo { create :doc }
    end

    factory :event_photo do
      photo { create :event }
    end

    factory :gallery_photo do
      photo { create :gallery }
    end
  end
end
