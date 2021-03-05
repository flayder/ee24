# encoding : utf-8
require 'spec_helper'

describe AccountController do

  let!(:current_user) { create :user, site: @site }
  let!(:user) { create :user, site: @site }

  before(:each) do
    @request.host = @site.domain
    user_login current_user
  end

  it "should create user visits" do
    lambda do
      get :profile, id: current_user.subdomain
    end.should change(UserVisit, :count).by(1)
  end

  describe 'GET profile' do
    context 'when own profile' do
      before :each do
        get :profile, id: current_user.subdomain
      end

      it 'should save ip for user' do
        current_user.last_ip.should_not == 'no ip yet'
      end

      it 'should assign @user' do
        assigns(:user).should eq(current_user)
      end

      it 'should render template profile' do
        response.should be_success
        response.should render_template('profile')
      end
    end

    context 'when someone else profile' do
      before :each do
        get :profile, id: user.subdomain
      end

      it 'should assign @user' do
        assigns(:user).should eq(user)
      end

      it 'should render template profile' do
        response.should be_success
        response.should render_template('profile')
      end
    end
  end

  describe 'friendship' do
    before do
      @request.env["HTTP_REFERER"] = "/"
    end

    describe 'POST add_friend_approve' do
      it 'initiates Friendship#add_friend' do
        Friendship.any_instance.should_receive(:add_friend).with(user.subdomain)
        post :add_friend_approve, user_id: user.subdomain
      end
    end

    describe 'POST friend_approved' do
      before { Friendship.new(current_user).add_friend(user.subdomain) }

      it 'initiates Friendship#approve_friend' do
        message = user.admin_messages.last
        Friendship.any_instance.should_receive(:approve_friend).with(message.id.to_s)
        post :friend_approved, id: message.id
      end
    end

    describe 'DELETE friend_not_approved' do
      before { Friendship.new(current_user).add_friend(user.subdomain) }

      it 'initiates Friendship#decline_friend' do
        message = user.admin_messages.last
        Friendship.any_instance.should_receive(:decline_friend).with(message.id.to_s)
        post :friend_not_approved, id: message.id
      end
    end

    describe 'DELETE del_friend' do
      before do
        current_user.friends << user
      end

      context 'when friendship exists' do
        it 'deletes friend from current_user friends' do
          Friendship.any_instance.should_receive(:delete_friend).with(user)
          delete :del_friend, user_id: user.subdomain
        end
      end
    end
  end
end
