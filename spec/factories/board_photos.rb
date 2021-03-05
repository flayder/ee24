FactoryGirl.define do
  factory :board_photo do
    image { fixture_file("ava.jpg") }
    photoable { create :vacancy }
  end
end
