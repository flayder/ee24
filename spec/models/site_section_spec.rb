# encoding : utf-8
require 'spec_helper'

describe SiteSection do
  
  let(:site) { create :site }
  let(:site_section) { create :site_section, :site => site }
  
  before(:each) do
    create_default_sections site
  end
  
  subject { site_section }
  
  it { should be_valid }
  # REFACTOR this with cooler matcher
  its(:'rubrics.count') { should eq(0) }  
    
  context 'when site is partner' do
    context 'when section is afisha' do
      let(:afisha_section) { create :section, :controller => 'news' }
      let(:partner_site_afisha_section) { create :partner_site_section, :section => afisha_section, :site => site }
    end
    
    context 'when section is news' do
      let(:news_section) { create :section, :controller => 'news' }
      let(:partner_site_news_section) { create :partner_site_section, :section => news_section }
    end
  end
end
