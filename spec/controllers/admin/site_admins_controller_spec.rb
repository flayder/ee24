# encoding : utf-8
require 'spec_helper'

describe Admin::SiteAdminsController do


  before(:each) do
    @request.host = @site.domain
  end

  context 'when user' do
    let(:current_user) { create :user }
    before(:each) do
      user_login current_user
    end

    it 'should redirect_to root_url if user' do
      get :index
      #expect { get :index }.to raise_error(CanCan::AccessDenied)
      expect(response).to redirect_to(root_url)
      # FIX как тут поймать 404, а не CanCan?
      #response.status.should eq(404)
    end

    context 'is editor' do
      let(:site_editor) { create :site_editor, :site => @site }
      before(:each) do
        user_login site_editor.user
      end

      it 'should redirect_to root_url if site editor' do
        #expect { get :index }.to raise_error(CanCan::AccessDenied)
        get :index
        expect(response).to redirect_to(root_url)
        # FIX как тут поймать 404, а не CanCan?
        #response.status.should eq(404)
      end
    end

    context 'is site admin' do
      let(:site_admin) { create :site_admin, :site => @site }
      before(:each) do
        user_login site_admin.user
      end

      it 'should render template if site admin' do
        get :index
        response.should be_success
      end
    end

    context 'is super admin' do
      let(:super_admin) { create :admin }
      before(:each) do
        user_login super_admin
      end

      it 'should render template if super admin' do
        get :index
        response.should be_success
      end
    end
  end

  context 'when no user' do
    it 'should redirect_to root_url' do
      get :index
      expect(response).to redirect_to(root_url)
      #expect { get :index }.to raise_error(CanCan::AccessDenied)
      # FIX как тут поймать 404, а не CanCan?
      #response.status.should eq(404)
    end
  end
end
