# encoding : utf-8
require 'spec_helper'

describe Admin::SocialWidgetCodesController do

  let!(:admin) { create :site_admin, :site => @site }
  let!(:social_widget_code) { create :social_widget_code, :site => @site }

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'assigns @social_widget_code' do
      assigns(:social_widget_codes).should eq(@site.social_widget_codes)
    end

    it 'renders the index template' do
      response.should be_success
      response.should render_template('index')
    end
  end

  describe 'GET edit' do
    before :each do
      get :edit, :id => social_widget_code.id
    end

    it 'assigns @social_widget_code' do
      assigns(:social_widget_code).should eq(social_widget_code)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'PUT update' do
    before :each do
      put :update, :id => social_widget_code.id
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => :index)
    end
  end

end
