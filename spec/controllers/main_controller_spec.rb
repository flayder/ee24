# encoding: utf-8
require 'spec_helper'

describe MainController do
  let!(:web_analytics_block){ create(:web_analytics_block, :site => @site) }
  let!(:vk_social_widget_code){ create(:social_widget_code, :site => @site, :widget_type => 'vk') }
  let!(:fb_social_widget_code){ create(:social_widget_code, :site => @site, :widget_type => 'fb') }
  let!(:main_block){ create :main_block, site: @site }

  before(:each) do
    ['persona', 'attractions', 'czech_beer', 'medical'].each { |e| create :dictionary, site: @site, link: e }
  end

  it "should redirect to user profile if subdomain is user's" do
    skip '*********** SHOULD BE REFACTORED OR REMOVED ************'
    user = create(:user)
    @request.host = "#{user.subdomain}.36on.ru"
    get :index

    response.status.should eq(404)
    response.should render_template(Rails.root.join('public', '404.html'))
  end

  it "should render 404 for any subdomain" do
    skip '*********** SHOULD BE REFACTORED OR REMOVED ************'
    @request.host = "#{Faker::Lorem.word}.36on.ru"
    get :index

    response.status.should eq(404)
    response.should render_template(Rails.root.join('public', '404.html'))
  end

  it 'should have web_analytics_block code' do
    @request.host = @site.domain

    get :index
    response.should be_success
    response.body.should include(web_analytics_block.body)
  end

  it 'has social_widget_codes' do
    pending '*********** SHOULD BE FIXED ************'
    get :index
    response.should be_success
    response.body.should include(vk_social_widget_code.code)
    response.body.should include(fb_social_widget_code.code)
  end

  it "should render 404 is there is a path with user's subdomain" do
    user = create(:user)
    @request.host = "#{user.subdomain}.36on.ru"

    lambda {
      get :blah
    }.should raise_error(AbstractController::ActionNotFound)
  end

  context 'when partner site' do
    before(:each) do
      create(:site, :domain => '100on.ru')
      Settings['default_host_name'] = '100on.ru'
    end

    after(:each) do
      Settings['default_host_name'] = '420on.cz'
    end

    let!(:partner_site){ create(:partner_site, :subdomain => 'makaroni4') }

    it 'should redirect to partner portal if subdomain is site subdomain' do
      pending 'Will turn it on after megalaunch'
      @request.host = "#{partner_site.subdomain}.100on.ru"
      get :index

      assigns(:site).should eq(partner_site)
      assigns(:current_subdomain).should eq('makaroni4')
    end

    it 'should redirect to partner portal if subdomain is site subdomain' do
      pending 'Will turn it on after megalaunch'
      user = create(:user, :login => 'makaroni4')
      @request.host = "#{user.subdomain}.100on.ru"
      get :index

      assigns(:site).should eq(partner_site)
      assigns(:current_subdomain).should eq('makaroni4')
    end
  end

  describe "handling error" do
    it "should render 500 for errors" do
      [
        AbstractController::ActionNotFound,
        LocalJumpError,
        CanCan::AccessDenied,
        ActionController::RoutingError
      ].each do |err|
        if Onru::Application.config.consider_all_requests_local
          pending "Onru::Application.config.consider_all_requests_local SHOULD BE SET TO \"FALSE\""
        end

        controller.stub(:index).and_raise(err)
        get :index

        response.should render_template(Rails.root.join('public', '500.html'))
      end
    end
  end

end
