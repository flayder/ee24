require 'spec_helper'

describe Search::NewsController do
  let!(:search_section) { create :section, :controller => 'search' }
  let!(:search_site_section) { create :site_section, :section => search_section, :site => @site}
  let!(:doc_global_rubric) { create :doc_global_rubric, site: @site, link: 'news' }

  before(:each) do
    ThinkingSphinx.stub(:search).and_return([])
    @request.host = @site.domain
  end

  describe 'logging' do
    let(:query) { Faker::Lorem.sentence }
    let(:search_query) { SearchQuery.last }

    it 'should create query record' do
      lambda {
        get :index, :search => query
      }.should change(SearchQuery, :count).by(1)

    end

    it 'should log query' do
      get :index, :search => query
      search_query.query.should eq(query)
    end
  end

  describe 'ad_codes' do
    let!(:search_section) { create :section, :controller => 'search' }
    let!(:search_site_section) { create :site_section, :section => search_section, :site => @site }
    let!(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_top', :site => @site }
    let!(:section_ad_code) { create :ad_code, :ad_section => search_site_section, :banner_type => 'horizontal_top', :site => @site }

    it 'should display right ad code on search news page' do
      get :index
      assigns(:ad_codes)[:horizontal_top].should have_content(section_ad_code.code)
    end
  end
end
