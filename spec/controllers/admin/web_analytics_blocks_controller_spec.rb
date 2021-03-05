# encoding : utf-8
require 'spec_helper'

describe Admin::WebAnalyticsBlocksController do

  let!(:admin) { create :site_admin, :site => @site }
  let!(:web_analytics_block) { create :web_analytics_block, :site => @site }

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'assigns @web_analytics_block' do
      assigns(:web_analytics_blocks).should eq(@site.web_analytics_blocks)
    end

    it 'renders the index template' do
      response.should be_success
      response.should render_template('index')
    end
  end

  describe 'GET edit' do
    before :each do
      get :edit, :id => web_analytics_block.id
    end

    it 'assigns @web_analytics_block' do
      assigns(:web_analytics_block).should eq(web_analytics_block)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'PUT update' do
    before :each do
      put :update, :id => web_analytics_block.id
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => :index)
    end
  end
end
