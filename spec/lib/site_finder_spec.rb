# encoding : utf-8
require 'spec_helper'

describe SiteFinder do  
  let!(:prague_site) { create :prague_site }
  
  it 'finds site' do
    request = stub(:subdomain => nil, :domain => prague_site.domain, :path => '/')
    SiteFinder.find_site(request).should eq(prague_site)
  end
end