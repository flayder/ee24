# encoding : utf-8
require 'spec_helper'

describe OmniauthSessionsController do


  before :each do
    @request.host = @site.domain
  end

  describe 'facebook auth' do
    it "should create user when facebook logged in via fb" do
      request.env["omniauth.auth"] = {:provider => 'facebook', 'uid' => '12345', 'info' => {'email' => 'some@mail.com'}}
      lambda do
        get :create
      end.should change(User, :count).by(1)
      response.should redirect_to('/')
    end

    it "should sign in user when he exists" do
      user = create(:user, :email => 'fb@example.com', :facebook_uid => '12345')
      request.env["omniauth.auth"] = {:provider => 'facebook', 'uid' => user.facebook_uid, 'info' => {'email' => user.email}}
      lambda do
        get :create
      end.should_not change(User, :count)
      response.should redirect_to('/')
      assigns[:user].facebook_uid.should == '12345'
    end
  end

  describe 'vkontakte auth' do
    it "should create user when vk id is provided" do
      request.env["omniauth.auth"] = {:provider => 'vkontakte', 'uid' => '12345', 'info' => {'name' => 'Anne Boleyn'}}
      lambda do
        get :create
      end.should change(User, :count).by(1)
      response.should redirect_to('/')
    end

    it "should sign in user when user with such vkontakte_uid exists" do
      user = create(:user, :vkontakte_uid => '12345')
      request.env["omniauth.auth"] = {:provider => 'vkontakte', 'uid' => user.vkontakte_uid, 'info' => {'name' => 'Ringo Starr'}}
      lambda do
        get :create
      end.should_not change(User, :count)
      response.should redirect_to('/')
      assigns[:user].vkontakte_uid.should == '12345'
    end
  end
end
