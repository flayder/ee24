require 'spec_helper'

describe Seo do
  let(:seo) { create :seo } 
  subject { seo }
  
  it { should be_valid }
  it { should belong_to(:site) }
  it { should belong_to(:seo) }

  describe 'news_keywords' do
    it 'should not be more than 10' do
      seo.news_keywords = Faker::Lorem.words(11).join(', ')
      seo.should_not be_valid
    end
  end
end
