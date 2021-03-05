# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :design_template, class: 'Design::Template' do
    name "MyString"
    body "MyText"
    site_id 1
  end
end
