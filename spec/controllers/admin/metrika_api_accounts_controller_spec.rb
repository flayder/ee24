require 'spec_helper'

describe Admin::MetrikaApiAccountsController do

  let!(:admin) { create :site_admin, :site => @site }

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET show' do
    before :each do
      get :show
    end

    it 'should assign @metrika_api_account' do
      assigns(:metrika_api_account).should  eq(@site.metrika_api_account)
    end

    it 'should render show template' do
      response.should be_success
      response.should render_template('show')
    end
  end

  describe 'GET url_phrases' do
    let!(:url) { create :metrika_api_account_url, :metrika_api_account => @site.metrika_api_account }
    let!(:query) { create :metrika_api_account_search_query, :url => url }

    before :each do
      get :url_phrases, :url => url.body
    end

    it 'should assign @url' do
      assigns(:url).should  eq(url)
    end

    it 'should render url_phrases template' do
      response.should be_success
      response.should render_template('url_phrases')
    end
  end
end
